# frozen_string_literal: true

require "test_helper"
require "database/setup"

module StorageTables
  class AttachmentTest < ActiveSupport::TestCase
    setup do
      @post = Post.create!(name: "Post")
    end

    test "getting a signed blob ID from an attachment" do
      blob = create_blob
      @post.image.attach(blob)

      signed_id = @post.image.signed_id

      assert_equal blob, StorageTables::Blob.find_signed!(signed_id)
      assert_equal blob, StorageTables::Blob.find_signed(signed_id)
    end
  end
end
