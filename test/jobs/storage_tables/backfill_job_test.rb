# frozen_string_literal: true

require "test_helper"

module StorageTables
  class BackfillJobTest < ActiveJob::TestCase
    setup do
      @checksum = "a" * 64
    end

    test "performs backfill with the given checksum" do
      StorageTables::Blob.service.stub(:backfill, true) do
        perform_enqueued_jobs do
          BackfillJob.perform_later(@checksum)
        end
      end
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
  end
end
