# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, query_constraints: [:checksum, :blob_key]

    delegate :signed_id, to: :blob

    validates :filename, presence: true

    def download
      association(:blob).klass.service.download("#{blob_key}#{checksum}==")
    end

    def path
      association(:blob).klass.service.path_for("#{blob_key}#{checksum}==")
    end
  end
end
