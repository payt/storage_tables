# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "models/helpers/url_generation_helper"

module StorageTables
  class AttachmentTest < ActiveSupport::TestCase
    include StorageTables::Helpers::UrlGenerationHelper

    setup do
      @user = User.create!(name: "Post")
    end

    # TODO: Signed_IDS do not support composite primary keys.
    # https://github.com/payt/storage_tables/issues/20
    # test "getting a signed blob ID from an attachment" do
    #   blob = create_blob
    #   @user.avatar.attach(blob)

    #   signed_id = @user.avatar.signed_id

    #   assert_equal blob, StorageTables::Blob.find_signed!(signed_id)
    #   assert_equal blob, StorageTables::Blob.find_signed(signed_id)
    # end

    test "when trying to upload same file twice, only one blob is present and the filename is replaced" do
      blob = create_blob
      @user.avatar.attach(blob, filename: "test.txt")

      assert_no_difference -> { StorageTables::Blob.count } do
        @user.avatar.attach(blob, filename: "test2.txt")
      end

      assert_equal "test2.txt", @user.avatar.filename.to_s
    end

    test "when trying to upload same file twice, only one blob is present" do
      blob = create_blob
      @user.avatar.attach(blob, filename: "test.txt")

      assert_no_difference -> { StorageTables::Blob.count } do
        @user.avatar.attach(blob, filename: "test.txt")
      end

      assert_equal "test.txt", @user.avatar.filename.to_s
    end

    test "when changing the attachment, only one attachment is present" do
      blob = create_blob
      @user.avatar.attach(blob, filename: "test.txt")
      new_blob = create_blob(data: "NewData")

      assert_no_difference -> { StorageTables::UserAvatarAttachment.count } do
        @user.avatar.attach(new_blob, filename: "test2.txt")
      end
      assert_equal @user.avatar.blob, new_blob
      assert_equal "test2.txt", @user.avatar.filename.to_s
    end

    test "when adding a new file without filename raises error" do
      blob = create_blob
      blob2 = create_blob(data: "NewData")
      @user.avatar.attach(blob, filename: "test.txt")

      assert_raises ArgumentError do
        @user.avatar.attach(blob2, filename: nil)
      end
    end

    test "when changing a file, the old one is replaced" do
      blob = create_blob
      blob2 = create_blob(data: "NewData")

      @user.avatar.attach(blob, filename: "test.txt")
      @user.avatar.attach(blob2, filename: "test.txt")

      assert_equal @user.avatar.blob, blob2
    end

    test "directly-uploaded blob identification for one attached occurs before validation" do
      blob = directly_upload_file_blob(filename: "racecar.jpg", content_type: "application/octet-stream")

      assert_blob_identified_before_owner_validated(@user, blob, "image/jpeg") do
        @user.avatar.attach(blob, filename: "racecar.jpg")
      end
    end

    test "directly-uploaded blob identification for many attached occurs before validation" do
      blob = directly_upload_file_blob(filename: "racecar.jpg", content_type: "application/octet-stream")

      assert_blob_identified_before_owner_validated(@user, blob, "image/jpeg") do
        @user.highlights.attach([blob, "racecar.jpg"])
      end
    end

    test "directly-uploaded blob identification for one attached occurs outside transaction" do
      blob = directly_upload_file_blob(filename: "racecar.jpg")

      assert_blob_identified_outside_transaction(blob) do
        @user.avatar.attach(blob, filename: "racecar.jpg")
      end
    end

    test "directly-uploaded blob identification for many attached occurs outside transaction" do
      blob = directly_upload_file_blob(filename: "racecar.jpg")

      assert_blob_identified_outside_transaction(blob) do
        @user.highlights.attach([blob, "racecar.jpg"])
      end
    end

    test "attachments can use includes" do
      @user.avatar.attach({ io: StringIO.new("STUFF"), content_type: "avatar/jpeg" }, filename: "town.jpg")
      findable = User.with_storage_avatar.find_by(name: "Post")

      assert_equal @user, findable
    end

    test "path can be created through the attachment" do
      attachment = @user.avatar.attach({ io: StringIO.new("STUFF"), content_type: "avatar/jpeg" }, filename: "town.jpg")

      assert_path_exists attachment.path
    end

    test "can create a path from attachment without touching a blob" do
      attachment = UserAvatarAttachment.new(checksum: "123456", blob_key: "a")
      full_checksum = attachment.full_checksum

      expected_path = "#{full_checksum[0]}/#{full_checksum[1..2]}/#{full_checksum[3..4]}/#{full_checksum}"

      assert attachment.path.end_with?(expected_path)
    end

    test "can create a relative path from attachment without touching a blob" do
      attachment = UserAvatarAttachment.new(checksum: "123456", blob_key: "a")
      full_checksum = attachment.full_checksum

      expected_path = "#{full_checksum[0]}/#{full_checksum[1..2]}/#{full_checksum[3..4]}/#{full_checksum}"

      assert_equal attachment.relative_path, expected_path
    end

    test "set a attachment to nil" do
      blob = create_blob(data: "NewData")

      @user.avatar.attach(blob, filename: "test.txt")

      @user.update!(avatar: nil)

      assert_not_predicate @user.avatar, :present?
      assert_predicate blob, :persisted?
    end

    test "when attachment is nil and also set to nil" do
      @user.update!(avatar: nil)

      assert_not_predicate @user.avatar, :present?
    end

    test "when attachment is set to nil and saved later" do
      blob = create_blob(data: "NewData")
      @user.avatar.attach(blob, filename: "test.txt")
      @user.save!

      @user.avatar = nil
      @user.save!

      assert_not_predicate @user.avatar, :present?
      assert_nil @user.avatar.filename
    end

    test "when no checksum is present, path raises an error" do
      error = assert_raises(StorageTables::ActiveRecordError) do
        UserAvatarAttachment.new.path
      end
      assert_equal "blob is nil", error.message
    end

    test "when no checksum is present, relative_path raises an error" do
      error = assert_raises(StorageTables::ActiveRecordError) do
        UserAvatarAttachment.new.relative_path
      end
      assert_equal "blob is nil", error.message
    end

    test "when no checksum is present, download raises an error" do
      error = assert_raises(StorageTables::ActiveRecordError) do
        UserAvatarAttachment.new.download
      end
      assert_equal "blob is nil", error.message
    end

    ## StorageTables::Attachment.where_checksum

    test "where_checksum" do
      blob = create_blob(data: "First blob")
      blob2 = create_blob(data: "Second blob")
      attachment = UserPhotoAttachment.create!(record: @user, blob: blob, filename: "test.txt")
      attachment2 = UserPhotoAttachment.create!(record: @user, blob: blob2, filename: "test.txt")

      checksum = blob.checksum

      search = UserPhotoAttachment.where_checksum(checksum)

      assert_includes search, attachment
      assert_not_includes search, attachment2
    end

    test "where_checksum with array" do
      blob = create_blob(data: "First blob")
      blob2 = create_blob(data: "Second blob")
      blob3 = create_blob(data: "Third blob")
      attachment = UserPhotoAttachment.create!(record: @user, blob: blob, filename: "test.txt")
      attachment2 = UserPhotoAttachment.create!(record: @user, blob: blob2, filename: "test.txt")
      attachment3 = UserPhotoAttachment.create!(record: @user, blob: blob3, filename: "test.txt")

      checksum = blob.checksum
      checksum2 = blob2.checksum

      search = UserPhotoAttachment.where_checksum([checksum, checksum2])

      assert_includes search, attachment
      assert_includes search, attachment2
      assert_not_includes search, attachment3
    end

    ## StorageTables::Attachment.find_by_checksum!

    test "find_by_checksum!" do
      blob = create_blob(data: "First blob")
      attachment = UserAvatarAttachment.create!(record: @user, blob: blob, filename: "test.txt")

      search = UserAvatarAttachment.find_by_checksum!(blob.checksum)

      assert_equal attachment, search
    end

    test "find_by_checksum! with non-existing checksum" do
      assert_raises(ActiveRecord::RecordNotFound) do
        UserAvatarAttachment.find_by_checksum!("non-existing-checksum")
      end
    end

    test "find_by_checksum with non-existing checksum does not raise" do
      result = UserAvatarAttachment.find_by_checksum("non-existing-checksum")

      assert_nil result
    end

    test "url" do
      blob = create_blob(data: "First blob")
      attachment = UserAvatarAttachment.create!(record: @user, blob: blob, filename: "test.txt")

      freeze_time do
        assert_equal expected_url_for(blob, disposition: :inline, filename: StorageTables::Filename.new("test.txt")),
                     attachment.url
      end
    end

    test "url with disposition" do
      blob = create_blob(data: "First blob")
      attachment = UserAvatarAttachment.create!(record: @user, blob: blob, filename: "test.txt")

      freeze_time do
        assert_equal expected_url_for(attachment.blob, disposition: :inline, filename: StorageTables::Filename.new("test.txt")),
                     attachment.url(disposition: :inline)
        assert_equal expected_url_for(attachment.blob, disposition: :attachment, filename: StorageTables::Filename.new("test.txt")),
                     attachment.url(disposition: :attachment)
      end
    end

    test "open with integrity" do
      create_file_blob(filename: "racecar.jpg").tap do |blob|
        attachment = UserAvatarAttachment.create!(record: @user, blob: blob, filename: "AvatarRacecar.jpg")
        attachment.open do |file|
          assert_predicate file, :binmode?
          assert_equal 0, file.pos
          assert file.path.end_with?(".jpg")
          assert_equal file_fixture("racecar.jpg").binread, file.read, "Expected downloaded file to match fixture file"
        end
      end
    end

    test "open in a custom tmpdir" do
      create_file_blob(filename: "racecar.jpg").tap do |blob|
        attachment = UserAvatarAttachment.create!(record: @user, blob: blob, filename: "AvatarRacecar.jpg")
        attachment.open(tmpdir: tmpdir = Dir.mktmpdir) do |file|
          assert_predicate file, :binmode?
          assert_equal 0, file.pos
          assert file.path.start_with?(tmpdir)
          assert file.path.end_with?(".jpg")
          assert_equal file_fixture("racecar.jpg").binread, file.read, "Expected downloaded file to match fixture file"
        end
      end
    end

    private

    def assert_blob_identified_before_owner_validated(owner, blob, content_type)
      validated_content_type = nil

      owner.class.validate do
        validated_content_type ||= blob.content_type
      end

      yield

      assert_equal content_type, validated_content_type
      assert_equal content_type, blob.reload.content_type
    end

    def assert_blob_identified_outside_transaction(blob, &)
      baseline_transaction_depth = ActiveRecord::Base.connection.open_transactions
      max_transaction_depth = -1

      track_transaction_depth = lambda do |*|
        max_transaction_depth = [ActiveRecord::Base.connection.open_transactions, max_transaction_depth].max
      end

      blob.stub(:identify_without_saving, track_transaction_depth, &)

      assert_equal 0, (max_transaction_depth - baseline_transaction_depth)
    end
  end
end
