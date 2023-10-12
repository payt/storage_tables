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

        def upload
          case attachable
          when ActionDispatch::Http::UploadedFile
            blob.upload_without_unfurling(attachable.open)
          when Pathname
            blob.upload_without_unfurling(attachable.open)
          when Rack::Test::UploadedFile
            blob.upload_without_unfurling(
              attachable.respond_to?(:open) ? attachable.open : attachable
            )
          when Hash
            blob.upload_without_unfurling(attachable.fetch(:io))
          when File
            blob.upload_without_unfurling(attachable)
          when StorageTables::Blob
          when String
          else
            raise(
              ArgumentError,
              "Could not upload: expected attachable, " \
              "got #{attachable.inspect}"
            )
          end
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
          when ActionDispatch::Http::UploadedFile
            StorageTables::Blob.build_after_unfurling(
              io: attachable.open,
              filename: attachable.original_filename,
              content_type: attachable.content_type
            )
          when Rack::Test::UploadedFile
            StorageTables::Blob.build_after_unfurling(
              io: attachable.respond_to?(:open) ? attachable.open : attachable,
              filename: attachable.original_filename,
              content_type: attachable.content_type
            )
          when Hash
            StorageTables::Blob.build_after_unfurling(**attachable)
          when String
            StorageTables::Blob.find_signed!(attachable)
          when File
            StorageTables::Blob.build_after_unfurling(
              io: attachable,
              filename: File.basename(attachable)
            )
          when Pathname
            StorageTables::Blob.build_after_unfurling(
              io: attachable.open,
              filename: File.basename(attachable)
            )
          else
            raise(
              ArgumentError,
              "Could not find or build blob: expected attachable, " \
              "got #{attachable.inspect}"
            )
          end
        end
      end
    end
  end
end
