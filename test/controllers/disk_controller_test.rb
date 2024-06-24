# frozen_string_literal: true

require "test_helper"
require "database/setup"

module StorageTables
  class DiskControllerTest < ActionDispatch::IntegrationTest
    test "directly uploading blob with integrity" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "text/plain" }

      assert_response :no_content
      assert_equal data, blob.download
    end

    test "directly uploading blob without integrity" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size,
                                              checksum: create_checksum("bad data")

      put blob.service_url_for_direct_upload, params: data

      assert_response :unprocessable_entity
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with mismatched content type" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "application/octet-stream" }

      assert_response :unprocessable_entity
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with different but equivalent content type" do
      data = name
      blob = create_blob_before_direct_upload(
        byte_size: data.size, checksum: create_checksum(data), content_type: "application/x-gzip"
      )

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "application/x-gzip" }

      assert_response :no_content
      assert_equal data, blob.download
    end

    test "directly uploading blob with mismatched content length" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size - 1,
                                              checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "text/plain" }

      assert_response :unprocessable_entity
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with invalid token" do
      put update_rails_disk_service_url(encoded_token: "invalid"),
          params: "Something else entirely!", headers: { "Content-Type" => "text/plain" }

      assert_response :not_found
    end

    def create_checksum(data)
      OpenSSL::Digest.new("SHA3-512").base64digest(data)
    end
  end
end
