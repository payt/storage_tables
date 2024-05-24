# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteMany < ActiveStorage::Attached::Changes::DeleteOne # :nodoc:
        def save
          record.public_send(:"#{name}_storage_attachments")&.delete
          record.attachment_changes.delete(name)
          record.public_send(:"#{name}_storage_attachments=", [])
        end
      end
    end
  end
end
