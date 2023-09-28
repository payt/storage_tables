# frozen_string_literal: true

module StorageTables
  class Attachment < ApplicationRecord
    self.abstract_class = true

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, primary_key: :checksum, foreign_key: :checksum

    delegate :signed_id, to: :blob
  end
end
