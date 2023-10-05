# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, primary_key: :checksum,
                      foreign_key: :checksum, inverse_of: :attachments

    delegate :signed_id, to: :blob
  end
end
