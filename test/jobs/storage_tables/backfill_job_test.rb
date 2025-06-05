# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BackfillJobTest < ActiveJob::TestCase
    backup_config = {
      primary: { service: "Disk", root: Dir.mktmpdir("active_storage_tests_primary") },
      backup: { service: "Backup", primary: "primary", backup: "original" },
      original: { service: "Disk", root: Dir.mktmpdir("active_storage_tests_original") }
    }

    SERVICE = StorageTables::Service.configure :backup, backup_config
    FIXTURE_DATA = ("a" * 64.kilobytes).freeze

    setup do
      @checksum = generate_checksum(FIXTURE_DATA)
      @service = self.class.const_get(:SERVICE)
    end

    test "performs backfill with the given checksum" do
      @service.backup.upload(@checksum, StringIO.new(FIXTURE_DATA))

      perform_enqueued_jobs do
        BackfillJob.perform_later(@checksum)
      end

      assert @service.primary.exist?(@checksum)
    end

    test "discards job when file is not found" do
      assert_raises(StorageTables::FileNotFoundError) do
        StorageTables::Blob.service.stub(:backfill, raise(StorageTables::FileNotFoundError)) do
          perform_enqueued_jobs do
            assert_no_enqueued_jobs do
              BackfillJob.perform_later(@checksum)

              assert_enqueued_with(job: BackfillJob, args: [@checksum])
            end
          end
        end
      end
    end

    test "retries on integrity error" do
      assert_raises(StorageTables::IntegrityError) do
        StorageTables::Blob.service.stub(:backfill, raise(StorageTables::IntegrityError)) do
          perform_enqueued_jobs do
            BackfillJob.perform_later(@checksum)

            assert_enqueued_with(job: BackfillJob, args: [@checksum])
          end
        end
      end
    end

    def generate_checksum(string)
      OpenSSL::Digest.new("SHA3-512").base64digest(string)
    end
  end
end
