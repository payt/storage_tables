# frozen_string_literal: true

require "service/shared_service_tests"

module StorageTables
  class Service
    class BackupServiceTest < ActiveSupport::TestCase
      backup_config = {
        primary: { service: "Disk", root: Dir.mktmpdir("active_storage_tests_primary") },
        backup: { service: "Backup", primary: "primary", backup: "original" },
        original: { service: "Disk", root: Dir.mktmpdir("active_storage_tests_original") }
      }

      SERVICE = StorageTables::Service.configure :backup, backup_config

      include StorageTables::Service::SharedServiceTests
      include ActiveJob::TestHelper

      teardown do
        FileUtils.rm_rf backup_config[:primary][:root]
        FileUtils.rm_rf backup_config[:original][:root]
      end

      test "name" do
        assert_equal :backup, @service.name
      end

      test "upload goes to primary service" do
        data = "Test data"
        checksum = generate_checksum(data)

        assert_changes -> { @service.primary.exist?(checksum) }, from: false, to: true do
          @service.upload(checksum, StringIO.new(data))
        end

        assert_not @service.backup.exist?(checksum), "Backup should not have the file after upload"
      end

      test "download falls back to backup service when primary is missing" do
        data = "Test data"
        checksum = generate_checksum(data)

        # Upload only to backup
        @service.backup.upload(checksum, StringIO.new(data))

        # Should download from backup and trigger backfill
        assert_equal data, @service.download(checksum)

        # Verify backfill happened
        assert @service.primary.exist?(checksum), "Primary should have the file after backfill"
      end

      test "exist? checks both primary and backup services" do
        data = "Test data"
        checksum = generate_checksum(data)

        assert_not @service.exist?(checksum), "File should not exist initially"

        # Upload to primary only
        @service.primary.upload(checksum, StringIO.new(data))

        assert @service.exist?(checksum), "Should find file in primary"

        # Remove from primary, upload to backup
        @service.primary.delete(checksum)
        @service.backup.upload(checksum, StringIO.new(data))

        assert @service.exist?(checksum), "Should find file in backup"
      end

      test "backfill job is enqueued when downloading from backup" do
        data = "Test data"
        checksum = generate_checksum(data)
        @service.backup.upload(checksum, StringIO.new(data))

        assert_enqueued_with(job: StorageTables::BackfillJob) do
          @service.download(checksum)
        end
      end
    end
  end
end
