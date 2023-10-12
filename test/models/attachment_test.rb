# frozen_string_literal: true

require "test_helper"
require "database/setup"

module StorageTables
  class AttachmentTest < ActiveSupport::TestCase
    setup do
      @user = User.create!(name: "Post")
    end

    test "getting a signed blob ID from an attachment" do
      blob = create_blob
      @user.avatar.attach(blob)

      signed_id = @user.avatar.signed_id

      assert_equal blob, StorageTables::Blob.find_signed!(signed_id)
      assert_equal blob, StorageTables::Blob.find_signed(signed_id)
    end

    test "when trying to upload same file twice, only one record is created" do
      blob = create_blob
      @user.avatar.attach(blob)

      assert_no_difference -> { StorageTables::Blob.count } do
        @user.avatar.attach(blob)
      end
    end

    test "directly-uploaded blob identification for one attached occurs before validation" do
      blob = directly_upload_file_blob(filename: "racecar.jpg", content_type: "application/octet-stream")

      assert_blob_identified_before_owner_validated(@user, blob, "image/jpeg") do
        @user.avatar.attach(blob)
      end
    end

    # TODO: Later add support for multiple attachments
    # test "directly-uploaded blob identification for many attached occurs before validation" do
    #   blob = directly_upload_file_blob(filename: "racecar.jpg", content_type: "application/octet-stream")

    #   assert_blob_identified_before_owner_validated(@user, blob, "image/jpeg") do
    #     @user.highlights.attach(blob)
    #   end
    # end

    test "directly-uploaded blob identification for one attached occurs outside transaction" do
      blob = directly_upload_file_blob(filename: "racecar.jpg")

      assert_blob_identified_outside_transaction(blob) do
        @user.avatar.attach(blob)
      end
    end

    # TODO: Later add support for multiple attachments
    # test "directly-uploaded blob identification for many attached occurs outside transaction" do
    #   blob = directly_upload_file_blob(filename: "racecar.jpg")

    #   assert_blob_identified_outside_transaction(blob) do
    #     @user.highlights.attach(blob)
    #   end
    # end

    test "attachments can use includes" do
      @user.avatar.attach(io: StringIO.new("STUFF"), filename: "town.jpg", content_type: "avatar/jpeg")
      findable = User.with_stored_avatar.find_by(name: "Post")

      assert_equal @user, findable
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

    def assert_blob_identified_outside_transaction(blob, &block)
      baseline_transaction_depth = ActiveRecord::Base.connection.open_transactions
      max_transaction_depth = -1

      track_transaction_depth = lambda do |*|
        max_transaction_depth = [ActiveRecord::Base.connection.open_transactions, max_transaction_depth].max
      end

      blob.stub(:identify_without_saving, track_transaction_depth, &block)

      assert_equal 0, (max_transaction_depth - baseline_transaction_depth)
    end
  end
end
