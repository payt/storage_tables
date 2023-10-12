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

    test "Can use includes" do
      @user.avatar.attach(io: StringIO.new("STUFF"), filename: "town.jpg", content_type: "avatar/jpeg")
      findable = User.with_stored_avatar.find_by(name: "Post")

      assert_equal @user, findable
    end
  end
end
