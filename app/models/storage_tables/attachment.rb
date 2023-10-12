# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    class_attribute :service_name

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, primary_key: :checksum,
                      foreign_key: :checksum, inverse_of: :attachments

    delegate :signed_id, to: :blob

    after_initialize do
      self.service_name ||= StorageTables::Blob.service.name
    end

    def download
      service.download(checksum)
    end

    def service
      StorageTables::Blob.services.fetch(service_name)
    end
  end
end
