# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/securerandom"

module StorageTables::Service::SharedServiceTests
  extend ActiveSupport::Concern

  FIXTURE_DATA = ("a" * 64.kilobytes).freeze

  included do
    setup do
      @checksum = OpenSSL::Digest.base64digest("SHA3-512", FIXTURE_DATA)
      @service = self.class.const_get(:SERVICE)
      @service.upload @checksum, StringIO.new(FIXTURE_DATA)
    end

    teardown do
      @service.delete @checksum
    end

    test "uploading without integrity" do
      data = "Something else entirely!"
      checksum = OpenSSL::Digest.base64digest("MD5", "bad data")

      assert_raises(ActiveStorage::IntegrityError) do
        @service.upload(checksum, StringIO.new(data))
      end

      assert_not @service.exist?(checksum)
    ensure
      @service.delete checksum
    end
  end
end
