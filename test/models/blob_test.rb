# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "setup" do
      blob = StorageTables::Blob.new

      assert_not blob.valid?
    end

    test "upload" do
      file = fixture_file_upload("files/1x1.png", "image/png")

      binding.pry
    end
  end
end
