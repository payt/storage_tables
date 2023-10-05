# frozen_string_literal: true

require "active_storage/service/disk_service"

module StorageTables
  module Service
    class DiskService < ActiveStorage::Service::DiskService
      private

      def path_for(key) # :nodoc:
        # Replace the forward slash with an underscore
        key = key.tr("/", "_")
        # Replace the plus sign with a minus sign
        key = key.tr("+", "-")

        File.join root, folder_for(key), key
      end

      def folder_for(key)
        [key[0], key[1..2], key[3..4]].join("/")
      end

      def ensure_integrity_of(key, checksum)
        return if OpenSSL::Digest.new("SHA3-512").file(path_for(key)).base64digest == checksum

        delete key
        raise ActiveStorage::IntegrityError
      end
    end
  end
end
