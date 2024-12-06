# frozen_string_literal: true

require "test_helper"
require "storage_tables/service/disk_service"
require "service/shared_service_tests"

module StorageTables
  class Service
    class DiskServiceTest < ActiveSupport::TestCase
      SERVICE = StorageTables::Service::DiskService.new(root: "/tmp")

      include StorageTables::Service::SharedServiceTests

      attr_reader :fake_checksum

      setup do
        @fake_checksum = "#{"a" * 86}==" # 86 characters + 2 padding
      end

      test "path_for" do
        assert_equal "/tmp/a/aa/aa/#{fake_checksum}", @service.path_for(fake_checksum)
      end

      test "relative_path_for" do
        assert_equal "a/aa/aa/#{fake_checksum}", @service.relative_path_for(fake_checksum)
      end

      test "URL generation without StorageTables::Current.url_options set" do
        StorageTables::Current.url_options = nil

        error = assert_raises ArgumentError do
          @service.url_for_direct_upload(fake_checksum, expires_in: 5.minutes, content_type: "image/png",
                                                        content_length: 123)
        end

        assert_equal(
          "Cannot generate URL using Disk service, please set StorageTables::Current.url_options.", error.message
        )
      end

      test "URL generation keeps working with StorageTables::Current.host set" do
        StorageTables::Current.url_options = { host: "https://example.com" }

        original_url_options = Rails.application.routes.default_url_options.dup
        Rails.application.routes.default_url_options.merge!(protocol: "http", host: "test.example.com", port: 3001)
        begin
          assert_match(%r{^http://example.com:3001/rails/storage_tables/disk/.*$},
                       @service.url_for_direct_upload(fake_checksum, expires_in: 5.minutes, content_type: "image/png",
                                                                     content_length: 123))
        ensure
          Rails.application.routes.default_url_options = original_url_options
        end
      end
    end
  end
end
