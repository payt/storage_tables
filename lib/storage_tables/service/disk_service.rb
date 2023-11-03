# frozen_string_literal: true

require "active_storage/service/disk_service"

module StorageTables
  module Service
    # Local disk storage service.
    class DiskService < ActiveStorage::Service::DiskService
      private

      def path_for(key) # :nodoc:
        # Replace the forward slash with an underscore
        # Replace the plus sign with a minus sign
        key = key.tr("/+", "_-")

        File.join root, folder_for(key), key
      end

      def folder_for(key)
        "#{key[0]}/#{key[1..2]}/#{key[3..4]}"
      end

      # We don't need to ensure the integrity of the file
      def ensure_integrity_of(key, checksum); end
    end
  end
end
