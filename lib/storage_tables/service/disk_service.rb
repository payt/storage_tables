# frozen_string_literal: true

require "active_storage/service/disk_service"

module StorageTables
  module Service
    # Local disk storage service.
    class DiskService < ActiveStorage::Service::DiskService
      def path_for(checksum) # :nodoc:
        # Replace the forward slash with an underscore
        # Replace the plus sign with a minus sign
        checksum = checksum.tr("/+", "_-")

        File.join root, folder_for(checksum), checksum
      end

      private

      def folder_for(checksum)
        "#{checksum[0]}/#{checksum[1..2]}/#{checksum[3..4]}"
      end

      # We don't need to ensure the integrity of the file
      def ensure_integrity_of(key, checksum); end
    end
  end
end
