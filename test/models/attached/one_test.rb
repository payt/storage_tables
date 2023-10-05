# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

module StorageTables
  class OneAttachedTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    include ActiveSupport::Testing::MethodCallAssertions

    setup do
      @user = Post.create!(name: "My Post")
    end

    test "creating a record with a File as attachable attribute" do
      @post = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))

      assert_equal "racecar.jpg", @post.image.filename.to_s
      assert_not_nil @post.image_storage_attachment
      assert_not_nil @post.image_storage_blob
    end

    ## TODO: Make it possible to create a record with an existing blob
    # See: https://github.com/payt/storage_tables/issues/12
    test "creating a record with an attachment where already one exists" do
      @post = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))

      assert_raises(ActiveRecord::RecordNotUnique) do
        @post2 = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))
      end

      # assert_equal @post.image_storage_blob, @post2.image_storage_blob
    end
  end
end
