# frozen_string_literal: true

module StorageTables
  # Provides asynchronous backfilling of missing files from the backup service to the primary service.
  class BackfillJob < ActiveJob::Base # rubocop:disable Rails/ApplicationJob
    queue_as { StorageTables.queues[:backfill] }

    discard_on StorageTables::FileNotFoundError
    retry_on StorageTables::IntegrityError, attempts: 10, wait: :polynomially_longer

    def perform(checksum)
      StorageTables::Blob.service.try(:backfill, checksum)
    end
  end
end
