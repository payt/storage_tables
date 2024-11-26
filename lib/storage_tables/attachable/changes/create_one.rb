# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create a new attachment from an attachable blob.
      class CreateOne
        include Helper

        attr_reader :name, :record, :attachable, :filename

        def initialize(name, record, attachable, filename = nil)
          @name = name
          @record = record
          @attachable = attachable
          @filename = filename || extract_filename(attachable)

          blob.identify_without_saving
        end

        def attachment
          @attachment ||= find_or_build_attachment
        end

        def blob
          @blob ||= find_or_build_blob
        end

        def save
          unless StorageTables::Blob.service.exist?(attachment.full_checksum)
            raise StorageTables::ActiveRecordError,
                  "No file exists with checksum #{attachment.full_checksum}, try uploading the file first. " \
                  "Use the `attach` or `attachment=` method to upload the file."
          end

          if attachment.persisted?
            # Do not change anything if nothing has changed
            return if attachment.filename == filename

            # Set the filename on the attachment
            attachment.filename = filename
          else
            # Delete the old attachment if it exists
            attachment.class.where(record:).delete_all
            record.public_send(:"#{name}_storage_blob=", blob)
          end
          record.public_send(:"#{name}_storage_attachment=", attachment)
        end

        private

        def find_or_build_attachment
          find_attachment || build_attachment
        end

        def build_attachment
          attachment_class_name.constantize.new(record:, blob:, filename:, blob_key: blob[:partition_key])
        end

        def attachment_class_name
          record.attachment_reflections[name].options[:class_name]
        end

        def find_attachment
          return unless record.public_send(:"#{name}_storage_blob") == blob

          record.public_send(:"#{name}_storage_attachment")
        end

        def find_or_build_blob
          case attachable
          when StorageTables::Blob
            attachable
          when ActionDispatch::Http::UploadedFile
            StorageTables::Blob.create_and_upload!(
              io: attachable.open,
              content_type: attachable.content_type
            )
          when Rack::Test::UploadedFile
            StorageTables::Blob.create_and_upload!(
              io: attachable.respond_to?(:open) ? attachable.open : attachable,
              content_type: attachable.content_type
            )
          when Hash
            from_hash(attachable)
          when String
            StorageTables::Blob.find_signed!(attachable)
          when File
            StorageTables::Blob.create_and_upload!(io: attachable)
          when Pathname
            StorageTables::Blob.create_and_upload!(io: attachable.open)
          when ActiveStorage::Blob
            StorageTables::Blob.create_and_upload!(io: StringIO.new(attachable.download))
          else
            raise(
              ArgumentError,
              "Could not find or build blob: expected attachable, " \
              "got #{attachable.inspect}"
            )
          end
        end

        def from_hash(attachable)
          return attachable[:blob] if attachable[:blob]
          return StorageTables::Blob.find_by_checksum!(attachable[:checksum]) if attachable[:checksum]

          StorageTables::Blob.create_and_upload!(**attachable.except(:filename))
        end
      end
    end
  end
end
