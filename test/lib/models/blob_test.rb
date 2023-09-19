# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "blob" do
      blob = StorageTables::Blob.new

      assert blob.save
    end
  end
end
