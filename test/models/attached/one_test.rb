# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

module StorageTables
  class OneAttachedTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    include ActiveSupport::Testing::MethodCallAssertions

    setup do
      @post = Post.create!(name: "My Post")
    end

    test "creating a record with a File as attachable attribute" do
      @post = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))

      assert_equal "racecar.jpg", @post.image.filename.to_s
      assert_not_nil @post.image_storage_attachment
      assert_not_nil @post.image_storage_blob
    end

    test "creating a record with an attachment where already one exists" do
      @post = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))
      @post2 = Post.create!(name: "My Post", image: fixture_file_upload("racecar.jpg"))

      assert_equal @post.image_storage_blob, @post2.image_storage_blob
    end

    test "attaching a new blob from a Hash to an existing record" do
      @post.image.attach io: StringIO.new("STUFF"), filename: "town.jpg", content_type: "image/jpeg"

      assert_not_nil @post.image_storage_attachment
    end

    test "attaching StringIO attachable to an existing record" do
      upload = Rack::Test::UploadedFile.new StringIO.new(""), original_filename: "test.txt"

      @post.image.attach upload

      assert_not_nil @post.image_storage_attachment
      assert_not_nil @post.image_storage_blob
    end

    test "creating a record with a Pathname as attachable attribute" do
      @post = Post.create!(name: "Dorian", image: file_fixture("racecar.jpg"))

      assert_not_nil @post.image_storage_attachment
      assert_not_nil @post.image_storage_blob
    end

    test "uploads the file when passing a Pathname as attachable attribute" do
      @post = Post.create!(name: "Dorian", image: file_fixture("racecar.jpg"))

      assert_nothing_raised { @post.image.download }
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

    test "attaching a new blob from an uploaded file to an existing record" do
      @post.image.attach fixture_file_upload("racecar.jpg")

      assert_equal "racecar.jpg", @post.image.filename.to_s
    end
  end
end
