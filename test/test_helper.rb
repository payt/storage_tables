# frozen_string_literal: true

require "simplecov"

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = "#{ActiveSupport::TestCase.fixture_path}/files"
  ActiveSupport::TestCase.fixtures :all
end

SERVICE_CONFIGURATIONS = begin
  ActiveSupport::ConfigurationFile.parse(File.expand_path("service/configurations.yml", __dir__)).deep_symbolize_keys
rescue Errno::ENOENT
  puts "Missing service configuration file in test/service/configurations.yml"
  {}
end

require "tmpdir"

Rails.configuration.active_storage.service_configurations = SERVICE_CONFIGURATIONS.merge(
  "local" => { "service" => "Disk", "root" => Dir.mktmpdir("active_storage_tests") }
).deep_stringify_keys

Rails.configuration.active_storage.service = "local"

class ActiveSupport::TestCase
  setup do
    ActiveStorage::Current.url_options = { protocol: "https://", host: "example.com", port: nil }
  end

  teardown do
    ActiveStorage::Current.reset
  end

  private

  def create_blob(filename: "racecar.jpg", content_type: "image/jpeg", metadata: nil, record: nil)
    StorageTables::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename,
                                           content_type: content_type, metadata: metadata, record: record
  end
end

require "support/models"
