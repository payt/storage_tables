# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

module StorageTables
  class DiskControllerTest < ActionDispatch::IntegrationTest
    test "directly uploading blob with integrity" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "text/plain" }

      assert_response :no_content
      assert_equal data, blob.download
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

    test "upload a pdf" do
      file = file_fixture("report.pdf")
      checksum = StorageTables::Checksum.from_file(file)

      blob = create_blob_before_direct_upload(byte_size: file.size, checksum:, content_type: "application/pdf")

      put blob.service_url_for_direct_upload, params: file.binread, headers: { "Content-Type" => "application/pdf" }

      assert_response :no_content
      assert blob.service.exist?(blob.checksum)
      assert_equal checksum, StorageTables::Checksum.from_io(blob.download)
    end

    test "directly uploading blob without integrity" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size,
                                              checksum: create_checksum("bad data")

      put blob.service_url_for_direct_upload, params: data

      assert_response :unprocessable_entity
      assert_match(/Received Content-Type does not match the expected value/, response.body)
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with mismatched content type" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "application/octet-stream" }

      assert_response :unprocessable_entity
      assert_match(/Received Content-Type does not match the expected value/, response.body)
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with mismatched content length" do
      data = name
      blob = create_blob_before_direct_upload byte_size: data.size - 1,
                                              checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "text/plain" }

      assert_response :unprocessable_entity
      assert_match(/Received file size does not match the expected value/, response.body)
      assert_not blob.service.exist?(blob.checksum)
    end

    test "directly uploading blob with invalid token" do
      put update_storage_tables_disk_service_url(encoded_token: "invalid"),
          params: "Something else entirely!", headers: { "Content-Type" => "text/plain" }

      assert_response :not_found
    end

    test "upload with different content" do
      data = "Hello, world!"
      mismatched_data = "Hello, world?"

      blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

      put blob.service_url_for_direct_upload, params: mismatched_data, headers: { "Content-Type" => "text/plain" }

      assert_response :unprocessable_entity
      assert_match(/File checksum does not match the expected value/, response.body)
      assert_not blob.service.exist?(blob.checksum)
    end

    test "when uploading fails" do
      StorageTables::Blob.service.stub :upload, ->(*) { raise IntegrityError } do
        data = name
        blob = create_blob_before_direct_upload byte_size: data.size, checksum: create_checksum(data)

        put blob.service_url_for_direct_upload, params: data, headers: { "Content-Type" => "text/plain" }

        assert_response :unprocessable_entity
        assert_not blob.service.exist?(blob.checksum)
      end
    end

    def create_checksum(data)
      StorageTables::Checksum.from_io(data)
    end
  end
end
