# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteMany < ActiveStorage::Attached::Changes::DeleteMany # :nodoc:
        def save
          klazz.where(klazz.primary_key => current_attachments.pluck(:record_id, :blob_key, :checksum)).delete_all
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

        def klazz
          current_attachments.first.class
        end
      end
    end
  end
end
