# frozen_string_literal: true

require "test_helper"
require "storage_tables/services/disk_service"
require "service/shared_service_tests"

module StorageTables
  module Services
    class DiskServiceTest < ActiveSupport::TestCase
      SERVICE = StorageTables::Services::DiskService.new(root: "/tmp")

      include StorageTables::Services::SharedServiceTests

      test "path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "/tmp/1/23/45/1234567890abcde-f==", @service.path_for(checksum)
      end

      test "relative_path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "1/23/45/1234567890abcde-f==", @service.relative_path_for(checksum)
      end
    end
  end
end
