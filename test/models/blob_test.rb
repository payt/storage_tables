# frozen_string_literal: true

require "test_helper"
require "database/setup"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "setup" do
      blob = StorageTables::Blob.new

      assert_not blob.valid?
    end

    test "upload" do
      blob = create_blob

      assert_predicate(blob, :persisted?)
      # Check that the blob was uploaded to the service.
      assert blob.service.exist?(blob.checksum)
    end
  end
end
