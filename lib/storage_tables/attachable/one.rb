# frozen_string_literal: true

module StorageTables
  module Attachable
    # Representation of a single attachment to a model.
    class One < ActiveStorage::Attached::One
      # Returns the associated attachment record.
      #
      # You don't have to call this method to access the attachment's methods as
      # they are all available at the model level.
      def attachment
        if change.present?
          change.attachment
        else
          record.public_send("#{name}_storage_attachment")
        end
      end
    end
  end
end
