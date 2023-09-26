# frozen_string_literal: true

require "test_helper"
require "database/setup"
require "active_support/testing/method_call_assertions"

class StorageTables::OneAttachedTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::MethodCallAssertions

  setup do
    @user = Post.create!(name: "My Post")
  end

  teardown do
    StorageTables::Blob.find_each(&:delete)
  end

  test "creating a record with a File as attachable attribute" do
    @user = Post.create!(name: "Dorian", image: file_fixture("racecar.jpg").open)

    assert_equal "image.gif", @user.avatar.filename.to_s
    assert_not_nil @user.avatar_attachment
    assert_not_nil @user.avatar_blob
  end
end
