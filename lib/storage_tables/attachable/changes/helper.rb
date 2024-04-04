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
      end
    end
  end
end
