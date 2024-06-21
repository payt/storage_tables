# frozen_string_literal: true

module StorageTables
  # Serves files stored with the disk service in the same way that the cloud services do.
  # This means using expiring, signed URLs that are meant for immediate access, not permanent linking.
  # Always go through the BlobsController, or your own authenticated controller, rather than directly
  # to the service URL.
  class DiskController < ActiveStorage::BaseController
    def update
      if (token = decode_verified_token)
        if acceptable_content?(token)
          StorageTables::Blob.service.upload token[:checksum], request.body
          head :no_content
        else
          head :unprocessable_entity
        end
      else
        head :not_found
      end
    rescue StorageTables::IntegrityError
      head :unprocessable_entity
    end

    private

    def decode_verified_token
      token = ActiveStorage.verifier.verified(params[:encoded_token], purpose: :blob_token)
      token&.deep_symbolize_keys
    end

    def acceptable_content?(token)
      token[:content_type] == request.content_mime_type && token[:content_length] == request.content_length
    end
  end
end
