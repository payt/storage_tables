# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create a new attachment from an attachable blob.
      class CreateOne < ActiveStorage::Attached::Changes::CreateOne
        def save
          record.public_send("#{name}_storage_attachment=", attachment)
          record.public_send("#{name}_storage_blob=", blob)
        end

        private

        def build_attachment
          attachment_service_name.constantize.new(record: record, name: name, blob: blob, filename: blob.filename.to_s,
                                                  blob_key: blob[:partition_key])
        end

        def attachment_service_name
          record.attachment_reflections[name].options[:class_name]
        end

        def find_attachment
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
              metadata: {
                filename: attachable.original_filename
              }
            )
          when Hash
            StorageTables::Blob.build_after_unfurling(
              **attachable.symbolize_keys
            )
          when String
            StorageTables::Blob.find_signed!(attachable)
          else
            raise ArgumentError, "Could not find or build blob: expected attachable, got #{attachable.inspect}"
          end
        end
      end
    end
  end
end