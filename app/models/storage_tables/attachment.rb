# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, query_constraints: [:checksum, :blob_key]

    delegate :byte_size, to: :blob

    validates :filename, presence: true

    def download
      association(:blob).klass.service.download(full_checksum)
    end

    def path
      association(:blob).klass.service.path_for(full_checksum)
    end

    def full_checksum
      "#{blob_key}#{checksum}=="
    end
  end
end
