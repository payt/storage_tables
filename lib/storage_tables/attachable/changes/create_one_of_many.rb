# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create one attachment for a one-of-many association.
      class CreateOneOfMany < Attachable::Changes::CreateOne
        private

        def find_attachment
          record.public_send("#{name}_storage_attachments").detect { |attachment| attachment.blob_id == blob.id }
        end
      end
    end
  end
end
