# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BlobTest < ActiveSupport::TestCase
    test "setup" do
      blob = StorageTables::Blob.new

      binding.pry
    end
  end
end
