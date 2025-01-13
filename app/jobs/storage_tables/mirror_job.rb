# frozen_string_literal: true

require "active_support/core_ext/object/try"

# Provides asynchronous mirroring of directly-uploaded blobs.
module StorageTables
  class StorageTables::MirrorJob < ActiveJob::Base #
    queue_as { StorageTables.queues[:mirror] }

    discard_on StorageTables::FileNotFoundError
    retry_on StorageTables::IntegrityError, attempts: 10, wait: :polynomially_longer

    def perform(checksum)
      StorageTables::Blob.service.try(:mirror, checksum)
    end
  end
end
