# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "setup" do
      blob = StorageTables::Blob.new

      assert_not blob.valid?
    end

    test "update checksum" do
      blob = create_blob

      assert_raises(ActiveRecord::StatementInvalid) do
        blob.update!(checksum: "1234567890")
      end
    end

    test "upload" do
      blob = create_blob

      assert_predicate(blob, :persisted?)
      # Check that the blob was uploaded to the service.
      assert_predicate blob, :on_disk?
    end

    test "identify without byte size" do
      blob = StorageTables::Blob.new(byte_size: 0)

      assert blob.identify_without_saving
    end

    test "created with custom metadata" do
      blob = create_blob metadata: { "author" => "DHH" }

      assert_predicate(blob, :persisted?)
      # Check that the blob was uploaded to the service.
      assert_predicate blob, :on_disk?
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
      assert_predicate blob, :on_disk?
    end

    test "Destroying a blob also removes the file on disk" do
      blob = create_blob
      blob.destroy!

      assert_not blob.service.exist?(blob.checksum)
    end

    test "Cannot destroy a blob that is referenced by an attachment" do
      blob = create_blob
      @user = User.create!(name: "My User")
      @user.avatar.attach blob, filename: "funky.jpg"

      assert_raises(StorageTables::ActiveRecordError) do
        blob.reload.destroy!
      end
    end

    test "Cannot destroy a blob that is connected to an attachment if deleted through SQL" do
      blob = create_blob
      @user = User.create!(name: "My User")
      @user.avatar.attach blob, filename: "funky.jpg"
      assert_raises(ActiveRecord::StatementInvalid) do
        ActiveRecord::Base.transaction do
          blob.reload.delete
        end
      end
    end

    ## ServiceUrl for direct upload
    test "service_url_for_direct_upload" do
      blob = create_blob

      url = blob.service_url_for_direct_upload

      assert_match(%r{/rails/storage_tables/disk/}, url)
    end

    test "url" do
      blob = create_blob

      expected_url = "https://example.com/rails/storage_tables/disk/#{blob.checksum}"

      assert_equal expected_url.first(46), blob.url.first(46)
    end

    ## URL's

    test "URLs expiring in 5 minutes" do
      blob = create_blob

      freeze_time do
        assert_equal expected_url_for(blob, disposition: :inline), blob.url
        assert_equal expected_url_for(blob, disposition: :attachment), blob.url(disposition: :attachment)
      end
    end

    test "URLs force content_type to binary and attachment as content disposition for content types served as binary" do
      blob = create_blob(content_type: "text/html")

      freeze_time do
        assert_equal expected_url_for(blob, disposition: :attachment, content_type: "application/octet-stream"),
                     blob.url
        assert_equal expected_url_for(blob, disposition: :attachment, content_type: "application/octet-stream"),
                     blob.url(disposition: :inline)
      end
    end

    test "URLs force attachment as content disposition when the content type is not allowed inline" do
      blob = create_blob(content_type: "application/zip")

      freeze_time do
        assert_equal expected_url_for(blob, disposition: :attachment, content_type: "application/zip"), blob.url
        assert_equal expected_url_for(blob, disposition: :attachment, content_type: "application/zip"),
                     blob.url(disposition: :inline)
      end
    end

    ## StorageTables::Blob.where_checksum

    test "where_checksum" do
      blob = create_blob(data: "First blob")
      blob2 = create_blob(data: "Second blob")

      checksum = blob.checksum

      search = Blob.where_checksum(checksum)

      assert_includes search, blob
      assert_not_includes search, blob2
    end

    test "where_checksum with array" do
      blob = create_blob(data: "First blob")
      blob2 = create_blob(data: "Second blob")
      blob3 = create_blob(data: "Third blob")

      checksum = blob.checksum
      checksum2 = blob2.checksum

      search = Blob.where_checksum([checksum, checksum2])

      assert_includes search, blob
      assert_includes search, blob2
      assert_not_includes search, blob3
    end

    ## StorageTables::Blob.find_by_checksum!

    test "find_by_checksum!" do
      blob = create_blob(data: "First blob")

      search = Blob.find_by_checksum!(blob.checksum)

      assert_equal blob, search
    end

    test "find_by_checksum! with non-existing checksum" do
      assert_raises(ActiveRecord::RecordNotFound) do
        Blob.find_by_checksum!("non-existing-checksum")
      end
    end

    ## StorageTables::Blob.existing_blob()

    test "existing_blob is deprecated" do
      assert_deprecated("StorageTables", StorageTables.deprecator) do
        Blob.existing_blob("non-existing-checksum")
      end
    end

    private

    def expected_url_for(blob, disposition: :attachment, content_type: nil, service_name: :local)
      content_type ||= blob.content_type

      key_params = { checksum: blob.checksum,
                     disposition: disposition, content_type: content_type, service_name: service_name }

      "https://example.com/rails/storage_tables/disk/#{StorageTables.verifier.generate(key_params,
                                                                                       expires_in: 5.minutes,
                                                                                       purpose: :blob_url)}"
    end
  end
end
