# frozen_string_literal: true

require "test_helper"
require "storage_tables/service/disk_service"

module StorageTables
  module Service
    class DiskServiceTest < ActiveSupport::TestCase
      setup do
        @service = StorageTables::Service::DiskService.new(root: "root_path")
      end

      test "path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "root_path/1/23/45/1234567890abcde-f==", @service.path_for(checksum)
      end

      test "relative_path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "1/23/45/1234567890abcde-f==", @service.relative_path_for(checksum)
      end
    end
  end
end
