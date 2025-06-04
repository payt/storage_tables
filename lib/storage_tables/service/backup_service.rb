# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module StorageTables
  class Service
    # A service that has a primary and a backup, this will fallback to the backup
    # if the primary is missing a file.
    class BackupService < Service
      attr_reader :primary, :backup

      delegate :delete, :url, :path_for, :upload, :url_for_direct_upload,
               :headers_for_direct_upload, :compose, to: :primary

      def download(checksum)
        primary.download(checksum)
      rescue StorageTables::FileNotFoundError
        backup.download(checksum)

        backfill_later(checksum)
      end

      def download_chunk(checksum, range)
        primary.download_chunk(checksum, range)
      rescue StorageTables::FileNotFoundError
        backup.download_chunk(checksum, range)

        backfill_later(checksum)
      end

      def exist?(checksum)
        primary.exist?(checksum) || backup.exist?(checksum)
      end

      def backfill_later(checksum)
        StorageTables::BackfillJob.perform_later checksum
      end

      def backfill(checksum)
        instrument(:backfill_from_backup, checksum:) do
          primary.open(checksum) do |io|
            io.rewind
            backup.upload checksum, io
          end
        end
      end

      # Stitch together from named services.
      def self.build(primary:, backup:, name:, configurator:, **) # :nodoc:
        new(
          primary: configurator.build(primary),
          backup: configurator.build(backup)
        ).tap do |service_instance|
          service_instance.name = name
        end
      end

      def initialize(primary:, backup:) # rubocop:disable Lint/MissingSuper
        @primary = primary
        @backup = backup
      end
    end
  end
end
