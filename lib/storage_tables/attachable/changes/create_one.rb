# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create a new attachment from an attachable blob.
      class CreateOne
        include Helper

        attr_reader :name, :record, :attachable, :filename, :attachment_attributes

        def initialize(name, record, attachable, filename = nil)
          @name = name
          @record = record
          @attachable = attachable
          @filename = filename || extract_filename(attachable)
          @attachment_attributes = permitted_attachment_attributes(extract_attachment_attributes(attachable))

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
            return if attachment.filename == filename && attachment_attributes_unchanged?

            # Set the filename and any extra attachment columns on the attachment
            attachment.assign_attributes(filename:, **attachment_attributes)
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
          attachment_class.new(record:, blob:, filename:, blob_key: blob[:partition_key],
                               **attachment_attributes)
        end

        # Keep only what the attachment class has declared writable. Anything else is dropped
        # rather than rejected: the caller that built the attachable cannot be expected to know
        # what a given attachment permits, and this is also what keeps :attachment_attributes from
        # reaching the columns StorageTables sets itself.
        def permitted_attachment_attributes(attributes)
          attributes.symbolize_keys.slice(*attachment_class.permitted_attachment_attributes)
        end

        # An attribute the attachment does not have counts as changed, so that #save goes on to
        # assign it and ActiveRecord raises UnknownAttributeError naming the offending key — the
        # same error a not-yet-persisted attachment gives — rather than a NoMethodError from here.
        def attachment_attributes_unchanged?
          attachment_attributes.all? do |attribute, value|
            attachment.has_attribute?(attribute) && attachment.public_send(attribute) == value
          end
        end

        def attachment_class
          @attachment_class ||= record.attachment_reflections[name].options[:class_name].constantize
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

          StorageTables::Blob.create_and_upload!(**attachable.except(:filename, :attachment_attributes))
        end
      end
    end
  end
end
