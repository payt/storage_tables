# frozen_string_literal: true

require "fileutils"
require "pathname"
require "openssl"
require "active_support/core_ext/numeric/bytes"

module StorageTables
  class Service
    # Local disk storage service.
    class DiskService < Service
      attr_accessor :root

      def initialize(root:, public: false, **)
        @root = root
        @public = public

        super()
      end

      def download(checksum, &block)
        if block
          instrument(:streaming_download, checksum:) do
            stream checksum, &block
          end
        else
          instrument(:download, checksum:) do
            File.binread path_for(checksum)
          rescue Errno::ENOENT
            raise StorageTables::FileNotFoundError
          end
        end
      end

      def download_chunk(checksum, range)
        instrument(:download_chunk, checksum:, range:) do
          File.open(path_for(checksum), "rb") do |file|
            file.seek range.begin
            file.read range.size
          end
        rescue Errno::ENOENT
          raise StorageTables::FileNotFoundError
        end
      end

      def delete(checksum)
        instrument(:delete, checksum:) do
          File.delete path_for(checksum)
        rescue Errno::ENOENT
          # Ignore files already deleted
        end
      end

      def exist?(checksum)
        instrument(:exist, checksum:) do |payload|
          answer = File.exist? path_for(checksum)
          payload[:exist] = answer
          answer
        end
      end

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

      def restore(_checksum, *_args)
        nil
      end

      private

      def private_url(checksum, expires_in:, content_type:, disposition:, **)
        generate_url(checksum, expires_in: expires_in, content_type: content_type,
                               disposition: disposition)
      end

      def public_url(checksum, content_type: nil, disposition: :attachment, **)
        generate_url(checksum, expires_in: nil, content_type: content_type,
                               disposition: disposition)
      end

      def generate_url(checksum, expires_in:, content_type:, disposition:)
        verified_key_with_expiration = StorageTables.verifier.generate(
          {
            checksum:,
            disposition:,
            content_type: content_type,
            service_name: name
          },
          expires_in: expires_in,
          purpose: :blob_url
        )
        url_helpers.show_storage_tables_disk_service_url(verified_key_with_expiration, **url_options)
      end

      def folder_for(checksum)
        "#{checksum[0]}/#{checksum[1..2]}/#{checksum[3..4]}"
      end

      def ensure_integrity_of(checksum)
        return if file_match?(checksum)

        delete checksum
        raise StorageTables::IntegrityError
      end

      def make_path_for(checksum)
        path_for(checksum).tap { |path| FileUtils.mkdir_p File.dirname(path) }
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

      def url_helpers
        @url_helpers ||= Rails.application.routes.url_helpers
      end

      def stream(checksum)
        File.open(path_for(checksum), "rb") do |file|
          while (data = file.read(5.megabytes))
            yield data
          end
        end
      rescue Errno::ENOENT
        raise StorageTables::FileNotFoundError
      end
    end
  end
end
