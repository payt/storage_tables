# frozen_string_literal: true

module StorageTables
  # Serves files stored with the disk service in the same way that the cloud services do.
  # This means using expiring, signed URLs that are meant for immediate access, not permanent linking.
  # Always go through the BlobsController, or your own authenticated controller, rather than directly
  # to the service URL.
  class DiskController < BaseController
    include StorageTables::FileServer

    skip_forgery_protection

    def show
      if encoded_checksum
        serve_file named_disk_service(encoded_checksum[:service_name]).path_for(encoded_checksum[:checksum]),
                   content_type: encoded_checksum[:content_type], disposition: encoded_checksum[:disposition]
      else
        head :not_found
      end
    rescue Errno::ENOENT
      head :not_found
    end

    def update
      return head :not_found unless token

      if invalid_content_type?
        render json: { error: "Received Content-Type does not match the expected value. Expected " \
                              "'#{token[:content_type]}', but got '#{request.content_mime_type}'. Please ensure " \
                              "the request Content-Type is correct." },
               status: :unprocessable_entity
      elsif invalid_content_length?
        render json: { error: "Received file size does not match the expected value. Expected " \
                              "'#{token[:content_length]}' bytes, but got '#{request.content_length}' bytes. " \
                              "Please ensure the request file_size is correct." }, status: :unprocessable_entity
      else
        StorageTables::Blob.service.upload token[:checksum], request.body
        head :no_content
      end
    rescue StorageTables::IntegrityError
      render json: { error: "File checksum does not match the expected value" }, status: :unprocessable_entity
    end

    private

    def encoded_checksum
      @encoded_checksum ||= StorageTables.verifier.verified(params[:encoded_checksum],
                                                            purpose: :blob_url)&.deep_symbolize_keys
    end

    def token
      @token ||= StorageTables.verifier.verified(params[:encoded_token], purpose: :blob_token)&.deep_symbolize_keys
    end

    def invalid_content_type?
      token[:content_type] != request.content_mime_type
    end

    def invalid_content_length?
      token[:content_length] != request.content_length
    end
  end
end
