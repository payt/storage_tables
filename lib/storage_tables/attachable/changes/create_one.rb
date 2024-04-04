# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create a new attachment from an attachable blob.
      class CreateOne
        attr_reader :name, :record, :attachable, :filename

        def initialize(name, record, attachable, filename)
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
          record.public_send(:"#{name}_storage_attachment=", attachment)
          record.public_send(:"#{name}_storage_blob=", blob)
        end

        private

        def extract_filename(attachable)
          case attachable
          when ActionDispatch::Http::UploadedFile, Rack::Test::UploadedFile
            attachable.original_filename
          when Pathname
            attachable.basename.to_s
          when Hash
            attachable.fetch(:filename)
          when ActiveStorage::Blob
            attachable.filename.to_s
          when File
            File.basename(attachable.path)
          end
        end

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
            StorageTables::Blob.build_after_unfurling(
              io: attachable.open,
              content_type: attachable.content_type
            )
          when Rack::Test::UploadedFile
            StorageTables::Blob.build_after_unfurling(
              io: attachable.respond_to?(:open) ? attachable.open : attachable,
              content_type: attachable.content_type
            )
          when Hash
            StorageTables::Blob.build_after_unfurling(**attachable.except(:filename))
          when String
            StorageTables::Blob.find_signed!(attachable)
          when File
            StorageTables::Blob.build_after_unfurling(io: attachable)
          when Pathname
            StorageTables::Blob.build_after_unfurling(io: attachable.open)
          when ActiveStorage::Blob
            StorageTables::Blob.build_after_unfurling(io: StringIO.new(attachable.download))
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
