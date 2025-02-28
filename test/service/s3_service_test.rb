# frozen_string_literal: true

require "service/shared_service_tests"
require "net/http"
require "database/setup"
require "minitest/hooks/test"
require "active_support/testing/method_call_assertions"

if SERVICE_CONFIGURATIONS[:s3]
  module StorageTables
    class Service
      class S3ServiceTest < ActiveSupport::TestCase
        include Minitest::Hooks

        SERVICE = StorageTables::Service.configure(:s3, SERVICE_CONFIGURATIONS)

        include StorageTables::Service::SharedServiceTests

        around do |&block|
          VCR.use_cassette("services/s3/#{name}") do
            super(&block)
          end
        end

        test "name" do
          assert_equal :s3, @service.name
        end

        test "direct upload" do
          data = "Something else entirely!"
          checksum = generate_checksum(data)
          content_md5 = OpenSSL::Digest::MD5.base64digest(data)
          url = @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "text/plain",
                                                         content_md5:, content_length: data.size)

          uri = URI.parse url
          request = Net::HTTP::Put.new uri.request_uri
          request.body = data
          request.add_field "Content-Type", "text/plain"
          request.add_field "Content-MD5", content_md5
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request request
          end

          assert_equal data, @service.download(checksum)
        ensure
          @service.delete checksum
        end

        test "direct upload with content disposition" do
          data = "Something else entirely!"
          checksum = generate_checksum(data)
          content_md5 = OpenSSL::Digest::MD5.base64digest(data)
          url = @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "text/plain",
                                                         content_length: data.size, content_md5:)

          uri = URI.parse url
          request = Net::HTTP::Put.new uri.request_uri
          request.body = data
          @service.headers_for_direct_upload(content_md5:, content_type: "text/plain",
                                             filename: StorageTables::Filename.new("test.txt"),
                                             disposition: :attachment).each do |k, v|
            request.add_field k, v
          end
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request request
          end

          assert_equal("attachment; filename=\"test.txt\"; filename*=UTF-8''test.txt",
                       @service.bucket.object(safe_checksum(checksum)).content_disposition)
        ensure
          @service.delete checksum
        end

        test "direct upload without content disposition" do
          data     = "Something else entirely!"
          checksum = generate_checksum(data)
          content_md5 = OpenSSL::Digest::MD5.base64digest(data)
          url = @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "text/plain",
                                                         content_length: data.size, content_md5:)

          uri = URI.parse url
          request = Net::HTTP::Put.new uri.request_uri
          request.body = data
          @service.headers_for_direct_upload(content_md5:, content_type: "text/plain",
                                             disposition: :attachment).each do |k, v|
            request.add_field k, v
          end
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request request
          end

          assert_equal("", @service.bucket.object(safe_checksum(checksum)).content_disposition)
        ensure
          @service.delete checksum
        end

        test "directly uploading file larger than the provided content-length does not work" do
          data     = "Some text that is longer than the specified content length"
          checksum = generate_checksum(data)
          content_md5 = OpenSSL::Digest::MD5.base64digest(data)
          url = @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "text/plain",
                                                         content_length: data.size - 1, content_md5:)

          uri = URI.parse url
          request = Net::HTTP::Put.new uri.request_uri
          request.body = data
          request.add_field "Content-Type", "text/plain"
          request.add_field "Content-MD5", content_md5
          upload_result = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request request
          end

          assert_equal "403", upload_result.code
          assert_raises StorageTables::FileNotFoundError do
            @service.download(checksum)
          end
        ensure
          @service.delete checksum
        end

        test "upload a zero byte file" do
          blob = directly_upload_file_blob filename: "empty_file.txt", content_type: nil
          user = User.create! name: "DHH"
          user.avatar.attach(blob, filename: "empty_file.txt")

          assert_equal user.avatar.blob, blob
        end

        test "signed URL generation" do
          url = @service.url(checksum, expires_in: 5.minutes,
                                       disposition: :inline, filename: ActiveStorage::Filename.new("avatar.png"),
                                       content_type: "image/png")

          assert_match(
            /s3(-[-a-z0-9]+)?\.(\S+)?amazonaws.com.*response-content-disposition=inline.*avatar\.png.*response-content-type=image%2Fpng/, url # rubocop:disable Layout/LineLength
          )
          assert_match SERVICE_CONFIGURATIONS[:s3][:bucket], url
        end

        test "uploading with server-side encryption" do
          service = build_service(upload: { server_side_encryption: "AES256" })

          begin
            data = "Something else entirely!"
            checksum = generate_checksum(data)
            service.upload checksum, StringIO.new(data)

            assert_equal "AES256", service.bucket.object(checksum.tr("/+", "_-")).server_side_encryption
          ensure
            service.delete checksum
          end
        end

        test "upload with content type" do
          data = "Something else entirely!"
          checksum = generate_checksum(data)
          content_type = "text/plain"

          @service.upload(
            checksum,
            StringIO.new(data),
            filename: "cool_data.txt",
            content_type:
          )

          assert_equal content_type, @service.bucket.object(safe_checksum(checksum)).content_type
        ensure
          @service.delete checksum
        end

        test "upload with custom_metadata" do
          data     = "Something else entirely!"
          checksum = generate_checksum(data)
          @service.upload(
            checksum,
            StringIO.new(data),
            content_type: "text/plain",
            custom_metadata: { "foo" => "baz" },
            filename: "custom_metadata.txt"
          )

          url = @service.url(checksum, expires_in: 2.minutes, disposition: :inline, content_type: "text/html",
                                       filename: StorageTables::Filename.new("test.html"))

          response = Net::HTTP.get_response(URI(url))

          assert_equal("baz", response["x-amz-meta-foo"])
        ensure
          @service.delete checksum
        end

        test "upload with content disposition" do
          data = "Something else entirely!"
          checksum = generate_checksum(data)

          @service.upload(
            checksum,
            StringIO.new(data),
            filename: StorageTables::Filename.new("cool_data.txt"),
            disposition: :attachment
          )

          assert_equal("attachment; filename=\"cool_data.txt\"; filename*=UTF-8''cool_data.txt",
                       @service.bucket.object(safe_checksum(checksum)).content_disposition)
        ensure
          @service.delete checksum
        end

        test "uploading a large object in multiple parts" do
          service = build_service(upload: { multipart_threshold: 5.megabytes })

          begin
            data = ("a" * 6.megabytes)
            checksum = generate_checksum(data)

            service.upload checksum, StringIO.new(data), checksum: OpenSSL::Digest::MD5.base64digest(data)

            assert_equal data, service.download(checksum)
          ensure
            service.delete checksum
          end
        end

        test "uploading a small object with multipart_threshold configured" do
          service = build_service(upload: { multipart_threshold: 5.megabytes })

          begin
            data = ("a" * 3.megabytes)
            checksum = generate_checksum(data)

            service.upload checksum, StringIO.new(data), checksum: OpenSSL::Digest::MD5.base64digest(data)

            assert_equal data, service.download(checksum)
          ensure
            service.delete checksum
          end
        end

        test "uploading an io that is not rewindable" do
          error = assert_raises ArgumentError do
            @service.upload checksum, 1
          end

          assert_equal "io must be rewindable", error.message
        end

        test "when destroying a blob from database fails" do
          Rails.configuration.storage_tables.service = "s3"
          blob = StorageTables::Blob.create_and_upload!(io: StringIO.new(FIXTURE_DATA))

          assert blob.service.exist?(blob.checksum)
          assert_kind_of StorageTables::Service::S3Service, blob.service

          assert_raises StorageTables::ActiveRecordError do
            blob.stub :destroy, ->(*) { raise StorageTables::ActiveRecordError } do
              blob.destroy!
            end
          end

          assert_predicate blob, :on_disk?
        end

        private

        def build_service(configuration)
          StorageTables::Service.configure :s3, SERVICE_CONFIGURATIONS.deep_merge(s3: configuration)
        end

        def safe_checksum(checksum)
          checksum.tr("+/", "-_")
        end
      end
    end
  end
else
  puts "Skipping S3 Service tests because no S3 configuration was supplied"
end
