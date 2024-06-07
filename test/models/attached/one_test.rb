# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

module StorageTables
  class OneAttachedTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    include ActiveSupport::Testing::MethodCallAssertions

    setup do
      @user = User.create!(name: "My User")
    end

    test "creating a record with a File as attachable attribute" do
      @user = User.create!(name: "Dorian")
      @user.avatar.attach file_fixture("racecar.jpg").open

      assert_equal "racecar.jpg", @user.avatar.filename.to_s
      assert_not_nil @user.avatar_storage_attachment
      assert_not_nil @user.avatar_storage_blob
    end

    test "uploads the file when passing a File as attachable attribute" do
      @user = User.create!(name: "Dorian")
      @user.avatar.attach file_fixture("racecar.jpg").open

      assert_nothing_raised { @user.avatar.download }
      assert_equal 1_124_062, @user.avatar.download.bytesize
    end

    test "uploads the file when set through setter" do
      @user.avatar = file_fixture("racecar.jpg")

      assert_nothing_raised { @user.save! }
      assert_equal "racecar.jpg", @user.avatar.filename.to_s
    end

    test "uploads the file when set through setter and set filename seperate" do
      @user.avatar = file_fixture("racecar.jpg")
      @user.avatar.filename = "racecar.jpg"

      assert_nothing_raised { @user.save! }
      assert_equal "racecar.jpg", @user.avatar.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.avatar.full_checksum)
      assert_equal 1_124_062, @user.avatar.download.bytesize
    end

    test "when assigning a empty blob it cannot save" do
      @user.avatar = Blob.new(byte_size: 0, checksum: Digest::MD5.base64digest(""))
      @user.avatar.filename = "racecar.jpg"

      error = assert_raises(StorageTables::ActiveRecordError) do
        @user.save!
      end

      assert_equal "No file exists with checksum 1B2M2Y8AsgTpgAmY7PhCfg==, try uploading the file first. " \
                   "Use the `attach` or `attachment=` method to upload the file.",
                   error.message
    end

    test "create a record with a ActiveStorage::Blob as attachable attribute" do
      blob = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("STUFF"), content_type: "avatar/jpeg",
                                                    filename: "town.jpg")

      @user.avatar.attach blob

      assert_not_nil @user.avatar_storage_attachment
      assert_equal "town.jpg", @user.avatar_storage_attachment.filename.to_s
    end

    test "creating a record with an attachment where already one exists" do
      @user.avatar.attach file_fixture("racecar.jpg").open
      @user2 = User.create!(name: "My User")
      @user2.avatar.attach file_fixture("racecar.jpg").open

      assert_equal @user.avatar_storage_blob, @user2.avatar_storage_blob
    end

    test "attaching a new blob from a Hash to an existing record" do
      @user.avatar.attach({ io: StringIO.new("STUFF"), content_type: "avatar/jpeg" }, filename: "town.jpg")

      assert_not_nil @user.avatar_storage_attachment
    end

    test "attaching a new blob from a Hash to an existing record with the filename in the hash" do
      @user.avatar.attach({ io: StringIO.new("STUFF"), content_type: "avatar/jpeg", filename: "town.jpg" })

      assert_not_nil @user.avatar_storage_attachment
      assert_equal "town.jpg", @user.avatar_storage_attachment.filename.to_s
    end

    test "attaching StringIO attachable to an existing record" do
      upload = Rack::Test::UploadedFile.new StringIO.new(""), original_filename: "test.txt"

      @user.avatar.attach upload, filename: "test.txt"

      assert_not_nil @user.avatar_storage_attachment
      assert_not_nil @user.avatar_storage_blob
    end

    test "attaching ActionDispatch::Http::UploadedFile attachable to an existing record" do
      upload = ActionDispatch::Http::UploadedFile.new({
        filename: "avatar.jpeg",
        type: "image/jpeg",
        tempfile: fixture_file_upload("racecar.jpg")
      })

      @user.avatar.attach upload

      assert_not_nil @user.avatar_storage_attachment
      assert_not_nil @user.avatar_storage_blob
    end

    test "creating a record with a Pathname as attachable attribute" do
      @user.avatar.attach file_fixture("racecar.jpg")

      assert_not_nil @user.avatar_storage_attachment
      assert_not_nil @user.avatar_storage_blob
    end

    test "uploads the file when passing a Pathname as attachable attribute" do
      @user.avatar.attach file_fixture("racecar.jpg"), filename: "racecar.jpg"

      assert_nothing_raised { @user.avatar.download }
    end

    test "creating a record with an existing blob attached" do
      user = User.create!(name: "New User")
      blob = create_blob
      user.avatar.attach blob, filename: "funky.jpg"

      assert_predicate user.avatar, :attached?
      assert_equal "funky.jpg", user.avatar.filename.to_s
      assert_equal 1, blob.reload.attachments_count
    end

    test "creating a record with an existing blob from a signed ID attached" do
      @user.avatar.attach create_blob.signed_id, filename: "funky.jpg"

      assert_predicate @user.avatar, :attached?
    end

    test "creating a record with an unexpected object attached" do
      error = assert_raises(ArgumentError) do
        @user.avatar.attach :foo, filename: "foo.txt"
      end

      assert_equal "Could not find or build blob: expected attachable, got :foo", error.message
    end

    test "upload a file in a transaction" do
      error = assert_raises(StorageTables::ActiveRecordError) do
        ActiveRecord::Base.transaction do
          @user.avatar.attach create_blob, filename: "foo.txt"
        end
      end

      assert_equal "Cannot upload a blob inside a transaction", error.message
    end

    test "attaching a new blob from an uploaded file to an existing record" do
      @user.avatar.attach fixture_file_upload("racecar.jpg"), filename: "racecar.jpg"

      assert_equal "racecar.jpg", @user.avatar.filename.to_s
    end

    test "attaching a new blob from an uploaded file to an existing, changed record" do
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.avatar.attach(fixture_file_upload("racecar.jpg"), filename: "racecar.jpg")

      assert_equal "racecar.jpg", @user.avatar.filename.to_s
      assert_not @user.avatar.persisted?
      assert_predicate @user, :will_save_change_to_name?

      @user.save!

      assert_equal "racecar.jpg", @user.reload.avatar.filename.to_s
    end

    test "successfully replacing an existing, dependent attachment on an existing record" do
      create_blob.tap do |old_blob|
        @user.avatar.attach old_blob, filename: "old.txt"

        @user.avatar.attach create_file_blob(filename: "report.pdf"), filename: "report.pdf"

        # Blobs are not deleted directly if no longer used.
        assert StorageTables::Blob.service.exist?(old_blob.checksum)

        assert_equal "report.pdf", @user.avatar.filename.to_s
      end
    end

    test "when uploading fails, the blob is not created" do
      StorageTables::Blob.service.stub :upload, ->(*) { raise ServiceError } do
        assert_no_difference -> { StorageTables::Blob.count } do
          assert_raises ServiceError do
            @user.avatar.attach(fixture_file_upload("racecar.jpg"), filename: "racecar.jpg")
          end
        end
      end
    end

    test "when uploading fails, with a existing blob" do
      blob = create_blob

      StorageTables::Blob.service.stub :upload, ->(*) { raise ServiceError } do
        assert_no_difference -> { StorageTables::Blob.count } do
          @user.avatar.attach(blob, filename: "racecar.jpg")
        end
      end
    end
  end
end
