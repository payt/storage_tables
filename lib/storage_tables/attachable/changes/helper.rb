# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Helper methods for attachable changes.
      module Helper
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

        # Uploads the attachable to the blob.
        def upload(attachable, blob, filename: nil)
          if ActiveRecord::Base.connection.open_transactions > MAX_TRANSACTIONS_OPEN
            raise StorageTables::ActiveRecordError, "Cannot upload a blob inside a transaction"
          end

          filename ||= extract_filename(attachable)

          case attachable
          when ActionDispatch::Http::UploadedFile, Pathname
            blob.upload_without_unfurling(attachable.open, filename:)
          when Rack::Test::UploadedFile
            blob.upload_without_unfurling(
              attachable.respond_to?(:open) ? attachable.open : attachable,
              filename:
            )
          when Hash
            blob.upload_without_unfurling(attachable.fetch(:io), filename:)
          when File
            blob.upload_without_unfurling(attachable, filename:)
          when ActiveStorage::Blob
            blob.upload_without_unfurling(StringIO.new(attachable.download), filename:)
          end
        rescue StandardError
          blob.destroy!
          raise
        end
      end
    end
  end
end
