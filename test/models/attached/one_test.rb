# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

module StorageTables
  class OneAttachedTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    include ActiveSupport::Testing::MethodCallAssertions

    setup do
      @pre_post = Post.create!(name: "My Post")
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

    test "creating a record with an existing blob attached" do
      post = Post.create!(name: "New Post", image: create_blob(filename: "funky.jpg"))

      assert_predicate post.image, :attached?
    end

    test "creating a record with an existing blob from a signed ID attached" do
      post = Post.create!(name: "New Post", image: create_blob(filename: "funky.jpg").signed_id)

      assert_predicate post.image, :attached?
    end

    test "creating a record with an unexpected object attached" do
      error = assert_raises(ArgumentError) { Post.create!(name: "Jason", image: :foo) }

      assert_equal "Could not find or build blob: expected attachable, got :foo", error.message
    end
  end
end
