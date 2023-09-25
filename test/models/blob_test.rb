# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "setup" do
      StorageTables::Blob.new
    end
  end
end
