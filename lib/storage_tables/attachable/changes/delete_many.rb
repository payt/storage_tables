# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteMany < ActiveStorage::Attached::Changes::DeleteMany # :nodoc:
        include ManyHelper

        def save
          delete_old_attachments(current_attachments)
          record.attachment_changes.delete(name)
          record.public_send(:"#{name}_storage_attachments=", [])
        end

        def current_attachments
          record.public_send(:"#{name}_storage_attachments")
        end

        def attachments
          StorageTables::Attachment.none
        end

        def blobs
          StorageTables::Blob.none
        end
      end
    end
  end
end
