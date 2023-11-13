# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    teardown do
      StorageTables::Blob.delete_all
    end

    test "setup" do
      blob = StorageTables::Blob.new

      assert_not blob.valid?
    end

    test "upload" do
      blob = create_blob

      assert_predicate(blob, :persisted?)
      # Check that the blob was uploaded to the service.
      assert blob.service.exist?(blob.checksum)
    end

    test "created with custom metadata" do
      blob = create_blob metadata: { "author" => "DHH" }

      assert_predicate(blob, :persisted?)
      # Check that the blob was uploaded to the service.
      assert blob.service.exist?(blob.checksum)
    end

    test "create_and_upload extracts content type from data" do
      blob = create_file_blob content_type: "application/octet-stream"

      assert_equal "image/jpeg", blob.content_type
    end

    test "create_after_upload! has the same effect as create_and_upload!" do
      data = "Some other, even more funky file"
      blob = StorageTables::Blob.create_and_upload!(io: StringIO.new(data), content_type: "application/octet-stream")

      assert_predicate blob, :persisted?
      assert_equal data, blob.download
    end

    test "create_and_upload sets byte size and checksum" do
      data = "Hello world!"
      blob = StorageTables::Blob.create_and_upload!(io: StringIO.new(data), content_type: "application/octet-stream")

      assert_predicate blob, :persisted?
      assert_equal data.length, blob.byte_size
      assert_equal OpenSSL::Digest.new("SHA3-512").base64digest(data), blob.checksum
    end

    test "create_and_upload! the same file twice" do
      blob = create_file_blob
      blob2 = create_file_blob

      assert_equal blob, blob2
    end

    test "download yields chunks" do
      blob   = create_blob data: "a" * 5.0625.megabytes
      chunks = []

      blob.download do |chunk|
        chunks << chunk
      end

      assert_equal 2, chunks.size
      assert_equal "a" * 5.megabytes, chunks.first
      assert_equal "a" * 64.kilobytes, chunks.second
    end

    test "Can also upload binary files" do
      blob = create_blob(content_type: "text/html")

      assert_predicate blob, :persisted?
      assert blob.service.exist?(blob.checksum)
    end
  end
end
