# frozen_string_literal: true

module StorageTables
  module Attached::Changes
    class CreateOne < ActiveStorage::Attached::Changes::CreateOne
      def build_attachment
        binding.pry
      end

      def attachment_service_name
        record.attachment_reflections[name].options[:class_name]
      end

      def find_attachment
        binding.pry
        return unless record.public_send("#{name}_storage_blob") == blob

        record.public_send("#{name}_storage_attachment")
      end

      def find_or_build_blob
        case attachable
        when StorageTables::Blob
          attachable
        when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
          StorageTables::Blob.build_after_unfurling(
            io: attachable.open,
            filename: attachable.original_filename,
            content_type: attachable.content_type,
            record: record
          )
        when Hash
          StorageTables::Blob.build_after_unfurling(
            **attachable.reverse_merge(
              record: record
            ).symbolize_keys
          )
        when String
          StorageTables::Blob.find_signed!(attachable, record: record)
        else
          raise ArgumentError, "Could not find or build blob: expected attachable, got #{attachable.inspect}"
        end
      end
    end
  end
end
