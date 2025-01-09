# frozen_string_literal: true

gem "aws-sdk-s3", "~> 1.48"

require "aws-sdk-s3"
require "active_support/core_ext/numeric/bytes"

module StorageTables
  class Service
    # = StorageTables \S3 \Service
    #
    # Wraps the Amazon Simple Storage Service (S3) as an Storage Tables service.
    # See StorageTables::Service for the generic API documentation that applies to all services.
    class S3Service < Service
      MULTIPART_THRESHOLD = 100.megabytes

      attr_reader :client, :bucket, :multipart_upload_threshold, :upload_options

      def initialize(bucket:, upload: {}, **) # rubocop:disable Lint/MissingSuper
        @client = Aws::S3::Resource.new(**)
        @bucket = @client.bucket(bucket)

        @multipart_upload_threshold = upload.delete(:multipart_threshold) || MULTIPART_THRESHOLD

        @upload_options = upload
      end

      def upload(checksum, io, filename: nil, content_type: nil, disposition: nil, custom_metadata: {}, **) # rubocop:disable Metrics/ParameterLists
        ensure_integrity_of(checksum, io)

        instrument(:upload, checksum:) do
          content_disposition = content_disposition_with(filename:, type: disposition) if disposition && filename

          if io.size < multipart_upload_threshold
            upload_with_single_part(checksum, io, content_type:,
                                                  content_disposition:, custom_metadata:)
          else
            upload_with_multipart checksum, io, content_type:, content_disposition:,
                                                custom_metadata:
          end
        end
      end

      def download(checksum, &block)
        if block
          instrument(:streaming_download, checksum:) do
            stream(checksum, &block)
          end
        else
          instrument(:download, checksum:) do
            object_for(checksum).get.body.string.force_encoding(Encoding::BINARY)
          rescue Aws::S3::Errors::NoSuchKey
            raise StorageTables::FileNotFoundError
          end
        end
      end

      def download_chunk(checksum, range)
        instrument(:download_chunk, checksum:, range:) do
          object_for(checksum).get(range: "bytes=#{range.begin}-#{range.exclude_end? ? range.end - 1 : range.end}")
                              .body.string.force_encoding(Encoding::BINARY)
        rescue Aws::S3::Errors::NoSuchKey
          raise StorageTables::FileNotFoundError
        end
      end

      def delete(checksum)
        instrument(:delete, checksum:) do
          object_for(checksum).delete
        end
      end

      def exist?(checksum)
        instrument(:exist, checksum:) do |payload|
          answer = object_for(checksum).exists?
          payload[:exist] = answer
          answer
        end
      end

      def url_for_direct_upload(checksum, expires_in:, content_type:, content_length:, content_md5:, # rubocop:disable Metrics/ParameterLists
                                custom_metadata: {})
        instrument(:url, checksum:) do |payload|
          generated_url = object_for(checksum).presigned_url :put, expires_in: expires_in.to_i,
                                                                   content_type:, content_length:,
                                                                   content_md5:,
                                                                   metadata: custom_metadata,
                                                                   whitelist_headers: ["content-length"],
                                                                   **upload_options

          payload[:url] = generated_url

          generated_url
        end
      end

      def headers_for_direct_upload(content_md5:, content_type:, filename: nil, disposition: nil, custom_metadata: {}, # rubocop:disable Metrics/ParameterLists
                                    **)
        content_disposition = content_disposition_with(type: disposition, filename:) if filename

        { "Content-Type" => content_type, "Content-MD5" => content_md5, "Content-Disposition" => content_disposition,
          **custom_metadata_headers(custom_metadata) }
      end

      private

      def private_url(checksum, expires_in:, filename:, disposition:, content_type:, **client_opts) # rubocop:disable Metrics/ParameterLists
        object_for(checksum).presigned_url :get, expires_in: expires_in.to_i,
                                                 response_content_disposition: content_disposition_with(
                                                   type: disposition, filename:
                                                 ), response_content_type: content_type, **client_opts
      end

      MAXIMUM_UPLOAD_PARTS_COUNT = 10_000
      MINIMUM_UPLOAD_PART_SIZE   = 5.megabytes

      def upload_with_single_part(checksum, io, content_type: nil, content_disposition: nil,
                                  custom_metadata: {})
        object_for(checksum).put(body: io, content_md5: compute_md5_checksum(io), content_type:,
                                 content_disposition:, metadata: custom_metadata, **upload_options)
      rescue Aws::S3::Errors::BadDigest
        # This should not be possible in our integration as we calculate the digest ourself
        # :nocov:
        raise StorageTables::IntegrityError
        # :nocov:
      end

      def upload_with_multipart(checksum, io, content_type: nil, content_disposition: nil, custom_metadata: {})
        part_size = [io.size.fdiv(MAXIMUM_UPLOAD_PARTS_COUNT).ceil, MINIMUM_UPLOAD_PART_SIZE].max

        object_for(checksum).upload_stream(content_type:, content_disposition:,
                                           part_size:, metadata: custom_metadata, **upload_options) do |out|
          IO.copy_stream(io, out)
        end
      end

      def object_for(checksum)
        bucket.object(refactored_checksum(checksum))
      end

      def ensure_integrity_of(checksum, io)
        raise StorageTables::IntegrityError unless checksum == compute_checksum(io)
      end

      # Reads the object for the given checksum in chunks, yielding each to the block.
      def stream(checksum)
        object = object_for(checksum)

        chunk_size = 5.megabytes
        offset = 0

        raise StorageTables::FileNotFoundError unless object.exists?

        while offset < object.content_length
          yield object.get(range: "bytes=#{offset}-#{offset + chunk_size - 1}").body.string
                      .force_encoding(Encoding::BINARY)
          offset += chunk_size
        end
      end

      def custom_metadata_headers(metadata)
        metadata.transform_keys { |key| "x-amz-meta-#{key}" }
      end

      def compute_md5_checksum(io)
        OpenSSL::Digest.new("MD5").tap do |checksum|
          read_buffer = "".b
          checksum << read_buffer while io.read(5.megabytes, read_buffer)

          io.rewind
        end.base64digest
      end
    end
  end
end
