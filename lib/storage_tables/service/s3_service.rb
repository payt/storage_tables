# frozen_string_literal: true

gem "aws-sdk-s3", "~> 1.48"

require "aws-sdk-s3"
require "active_support/core_ext/numeric/bytes"

module StorageTables
  # = StorageTables \S3 \Service
  #
  # Wraps the Amazon Simple Storage Service (S3) as an Storage Tables service.
  # See StorageTables::Service for the generic API documentation that applies to all services.
  class Service::S3Service < Service
    MULTIPART_THRESHOLD = 100.megabytes

    attr_reader :client, :bucket, :multipart_upload_threshold, :upload_options

    def initialize(bucket:, upload: {}, public: false, **)
      super

      @client = Aws::S3::Resource.new(**)
      @bucket = @client.bucket(bucket)

      @multipart_upload_threshold = upload.delete(:multipart_threshold) || MULTIPART_THRESHOLD
      @public = public

      @upload_options = upload
      @upload_options[:acl] = "public-read" if public?
    end

    def upload(checksum, io, filename: nil, content_type: nil, disposition: nil, custom_metadata: {}, **)
      instrument(:upload, key:, checksum:) do
        content_disposition = content_disposition_with(filename:, type: disposition) if disposition && filename

        if io.size < multipart_upload_threshold
          upload_with_single_part(checksum, io, checksum, content_type:,
                                                          content_disposition:, custom_metadata:)
        else
          upload_with_multipart checksum, io, content_type:, content_disposition:,
                                              custom_metadata:
        end
      end
    end

    def download(key, &block)
      if block
        instrument(:streaming_download, key:) do
          stream(key, &block)
        end
      else
        instrument(:download, key:) do
          object_for(key).get.body.string.force_encoding(Encoding::BINARY)
        rescue Aws::S3::Errors::NoSuchKey
          raise ActiveStorage::FileNotFoundError
        end
      end
    end

    def download_chunk(key, range)
      instrument(:download_chunk, key:, range:) do
        object_for(key).get(range: "bytes=#{range.begin}-#{range.exclude_end? ? range.end - 1 : range.end}").body.string.force_encoding(Encoding::BINARY)
      rescue Aws::S3::Errors::NoSuchKey
        raise ActiveStorage::FileNotFoundError
      end
    end

    def delete(key)
      instrument(:delete, key:) do
        object_for(key).delete
      end
    end

    def delete_prefixed(prefix)
      instrument(:delete_prefixed, prefix:) do
        bucket.objects(prefix:).batch_delete!
      end
    end

    def exist?(key)
      instrument(:exist, key:) do |payload|
        answer = object_for(key).exists?
        payload[:exist] = answer
        answer
      end
    end

    def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:, custom_metadata: {})
      instrument(:url, key:) do |payload|
        generated_url = object_for(key).presigned_url :put, expires_in: expires_in.to_i,
                                                            content_type:, content_length:, content_md5: checksum,
                                                            metadata: custom_metadata, whitelist_headers: ["content-length"], **upload_options

        payload[:url] = generated_url

        generated_url
      end
    end

    def headers_for_direct_upload(_key, content_type:, checksum:, filename: nil, disposition: nil, custom_metadata: {},
                                  **)
      content_disposition = content_disposition_with(type: disposition, filename:) if filename

      { "Content-Type" => content_type, "Content-MD5" => checksum, "Content-Disposition" => content_disposition,
        **custom_metadata_headers(custom_metadata) }
    end

    def compose(source_keys, destination_key, filename: nil, content_type: nil, disposition: nil, custom_metadata: {})
      content_disposition = content_disposition_with(type: disposition, filename:) if disposition && filename

      object_for(destination_key).upload_stream(
        content_type:,
        content_disposition:,
        part_size: MINIMUM_UPLOAD_PART_SIZE,
        metadata: custom_metadata,
        **upload_options
      ) do |out|
        source_keys.each do |source_key|
          stream(source_key) do |chunk|
            IO.copy_stream(StringIO.new(chunk), out)
          end
        end
      end
    end

    private

    def private_url(key, expires_in:, filename:, disposition:, content_type:, **client_opts)
      object_for(key).presigned_url :get, expires_in: expires_in.to_i,
                                          response_content_disposition: content_disposition_with(type: disposition, filename:),
                                          response_content_type: content_type, **client_opts
    end

    def public_url(key, **client_opts)
      object_for(key).public_url(**client_opts)
    end

    MAXIMUM_UPLOAD_PARTS_COUNT = 10_000
    MINIMUM_UPLOAD_PART_SIZE   = 5.megabytes

    def upload_with_single_part(checksum, io, content_type: nil, content_disposition: nil,
                                custom_metadata: {})
      md5_checksum = Digest::MD5.digest(io.read)
      object_for(key).put(body: io, content_md5: checksum, content_type:,
                          content_disposition:, metadata: custom_metadata, **upload_options)
    rescue Aws::S3::Errors::BadDigest
      raise ActiveStorage::IntegrityError
    end

    def upload_with_multipart(key, io, content_type: nil, content_disposition: nil, custom_metadata: {})
      part_size = [io.size.fdiv(MAXIMUM_UPLOAD_PARTS_COUNT).ceil, MINIMUM_UPLOAD_PART_SIZE].max

      object_for(key).upload_stream(content_type:, content_disposition:,
                                    part_size:, metadata: custom_metadata, **upload_options) do |out|
        IO.copy_stream(io, out)
      end
    end

    def object_for(key)
      bucket.object(key)
    end

    # Reads the object for the given key in chunks, yielding each to the block.
    def stream(key)
      object = object_for(key)

      chunk_size = 5.megabytes
      offset = 0

      raise ActiveStorage::FileNotFoundError unless object.exists?

      while offset < object.content_length
        yield object.get(range: "bytes=#{offset}-#{offset + chunk_size - 1}").body.string.force_encoding(Encoding::BINARY)
        offset += chunk_size
      end
    end

    def custom_metadata_headers(metadata)
      metadata.transform_keys { |key| "x-amz-meta-#{key}" }
    end
  end
end