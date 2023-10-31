# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    class_attribute :service_name

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, primary_key: :checksum, # rubocop:disable Rails/InverseOf
                      foreign_key: :checksum

    delegate :signed_id, to: :blob

    def download
      association(:blob).klass.service.download(checksum)
    end
  end
end
