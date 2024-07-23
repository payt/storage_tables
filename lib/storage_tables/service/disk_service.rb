# frozen_string_literal: true

require "active_storage/service/disk_service"

module StorageTables
  class Service
    # Local disk storage service.
    class DiskService < ActiveStorage::Service::DiskService
      def path_for(checksum) # :nodoc:
        File.join root, folder_for(refactored_checksum(checksum)), refactored_checksum(checksum)
      end

      def relative_path_for(checksum)
        File.join folder_for(refactored_checksum(checksum)), refactored_checksum(checksum)
      end

      def upload(checksum, io, **)
        # Prevent uploading the same file twice
        return if exist?(checksum) && file_match?(checksum)

        instrument(:upload, checksum:) do
          IO.copy_stream(io, make_path_for(checksum))
          ensure_integrity_of(checksum)
        end
      end

      def url_for_direct_upload(checksum, expires_in:, content_type:, content_length:)
        instrument(:url, checksum:) do |payload|
          verified_token_with_expiration = StorageTables.verifier.generate(
            {
              checksum:,
              content_type:,
              content_length:
            },
            expires_in:,
            purpose: :blob_token
          )

          url_helpers.update_storage_tables_disk_service_url(verified_token_with_expiration,
                                                             url_options).tap do |generated_url|
            payload[:url] = generated_url
          end
        end
      end

      private

      def refactored_checksum(checksum)
        # Replace the forward slash with an underscore
        # Replace the plus sign with a minus sign
        checksum.tr("/+", "_-")
      end

      def folder_for(checksum)
        "#{checksum[0]}/#{checksum[1..2]}/#{checksum[3..4]}"
      end

      def ensure_integrity_of(checksum)
        return if file_match?(checksum)

        delete checksum
        raise StorageTables::IntegrityError
      end

      def file_match?(checksum)
        OpenSSL::Digest.new("SHA3-512").file(path_for(checksum)).base64digest == checksum
      end

      def url_options
        if StorageTables::Current.url_options.blank?
          raise ArgumentError, "Cannot generate URL using Disk service, please set StorageTables::Current.url_options."
        end

        StorageTables::Current.url_options
      end
    end
  end
end
