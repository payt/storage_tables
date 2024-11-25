# frozen_string_literal: true

require "simplecov"
require "dotenv/load"

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
require "rails/test_help"
require_relative 'support/vcr'

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)

SERVICE_CONFIGURATIONS = begin
  ActiveSupport::ConfigurationFile.parse(File.expand_path("service/configurations.yml", __dir__)).deep_symbolize_keys
rescue Errno::ENOENT
  puts "Missing service configuration file in test/service/configurations.yml"
  {}
end

require "tmpdir"

Rails.configuration.active_storage.service_configurations = SERVICE_CONFIGURATIONS.merge(
  "local" => { "service" => "Disk", "root" => Dir.mktmpdir("storage_tables_tests") }
).deep_stringify_keys

Rails.configuration.active_storage.service = "local"

module ActiveSupport
  class TestCase
    self.file_fixture_path = File.expand_path("fixtures/files", __dir__)

    setup do
      StorageTables::Current.url_options = { protocol: "https://", host: "example.com", port: nil }
    end

    teardown do
      StorageTables::Current.reset
    end

    private

    def create_blob(data: "hello world", content_type: "image/jpeg", metadata: nil)
      StorageTables::Blob.create_and_upload!(io: StringIO.new(data), content_type:, metadata:)
    end

    def create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg", metadata: nil)
      StorageTables::Blob.create_and_upload!(
        io: fixture_file_upload(filename).open, content_type:, metadata:
      )
    end

    def create_blob_before_direct_upload(byte_size:, checksum:, content_type: "text/plain")
      StorageTables::Blob.create_before_direct_upload!(byte_size:, checksum:, content_type:)
    end

    def build_blob_after_unfurling(data: "Hello world!", content_type: "text/plain")
      StorageTables::Blob.build_after_unfurling(io: StringIO.new(data), content_type:)
    end

    def directly_upload_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
      file = file_fixture(filename)
      byte_size = file.size
      checksum = OpenSSL::Digest.new("SHA3-512").file(file).base64digest

      create_blob_before_direct_upload(byte_size:, checksum:, content_type:).tap do |_blob|
        service = StorageTables::Blob.service.try(:primary) || StorageTables::Blob.service
        service.upload(checksum, file.open)
      end
    end

    def fixture_file_upload(filename)
      Rack::Test::UploadedFile.new file_fixture(filename).to_s
    end
  end
end

require "support/models"
