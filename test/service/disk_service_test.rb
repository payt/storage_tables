# frozen_string_literal: true

require "test_helper"
require "storage_tables/service/disk_service"
require "service/shared_service_tests"

module StorageTables
  module Service
    class DiskServiceTest < ActiveSupport::TestCase
      SERVICE = StorageTables::Service::DiskService.new(root: "/tmp")

      include StorageTables::Service::SharedServiceTests

      test "path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "/tmp/1/23/45/1234567890abcde-f==", @service.path_for(checksum)
      end

      test "relative_path_for" do
        checksum = "1234567890abcde+f=="

        assert_equal "1/23/45/1234567890abcde-f==", @service.relative_path_for(checksum)
      end

      test "URL generation without StorageTables::Current.url_options set" do
        checksum = "1234567890abcde+f=="
        StorageTables::Current.url_options = nil

        error = assert_raises ArgumentError do
          @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "image/png",
                                                   content_length: 123)
        end

        assert_equal(
          "Cannot generate URL for #{checksum} using Disk service, " \
          "please set StorageTables::Current.url_options.", error.message
        )
      end

      test "URL generation keeps working with StorageTables::Current.host set" do
        checksum = "1234567890abcde+f=="
        StorageTables::Current.url_options = { host: "https://example.com" }

        original_url_options = Rails.application.routes.default_url_options.dup
        Rails.application.routes.default_url_options.merge!(protocol: "http", host: "test.example.com", port: 3001)
        begin
          assert_match(%r{^http://example.com:3001/rails/storage_tables/disk/.*$},
                       @service.url_for_direct_upload(checksum, expires_in: 5.minutes, content_type: "image/png",
                                                                content_length: 123))
        ensure
          Rails.application.routes.default_url_options = original_url_options
        end
      end
    end
  end
end
