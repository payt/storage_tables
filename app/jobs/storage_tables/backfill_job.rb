# frozen_string_literal: true

module StorageTables
  # Provides asynchronous backfilling of missing files from the backup service to the primary service.
  class BackfillJob < ActiveJob::Base # rubocop:disable Rails/ApplicationJob
    queue_as { StorageTables.queues[:backfill] }

    retry_on StorageTables::FileNotFoundError, attempts: 5, wait: :polynomially_longer
    retry_on StorageTables::IntegrityError, attempts: 5, wait: :polynomially_longer

    def perform(checksum)
      StorageTables::Blob.service.try(:backfill, checksum)
    end
  end
end
