# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, foreign_key: [:checksum, :blob_key]

    delegate :byte_size, :content_type, to: :blob

    validates :filename, presence: true

    def download
      association(:blob).klass.service.download(full_checksum)
    end

    def path
      association(:blob).klass.service.path_for(full_checksum)
    end

    def relative_path
      association(:blob).klass.service.relative_path_for(full_checksum)
    end

    def full_checksum
      raise StorageTables::ActiveRecordError, "blob is nil" unless checksum

      "#{blob_key}#{checksum}=="
    end

    # Returns an StorageTables::Filename instance of the filename that can be
    # queried for basename, extension, and a sanitized version of the filename
    # that's safe to use in URLs.
    def filename
      StorageTables::Filename.new(self[:filename])
    end
  end
end
