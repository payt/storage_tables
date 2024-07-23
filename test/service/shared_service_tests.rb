# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/securerandom"

module StorageTables
  class Service
    module SharedServiceTests
      extend ActiveSupport::Concern

      FIXTURE_DATA = ("a" * 64.kilobytes).freeze

      included do
        setup do
          @service = self.class.const_get(:SERVICE)
        end

        test "uploading without integrity" do
          data = "Something else entirely!"
          checksum = OpenSSL::Digest.new("SHA3-512").base64digest(FIXTURE_DATA)

          assert_raises(StorageTables::IntegrityError) do
            @service.upload(checksum, StringIO.new(data))
          end

          assert_not @service.exist?(checksum)
        ensure
          @service.delete checksum
        end
      end
    end
  end
end
