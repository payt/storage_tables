# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteMany # :nodoc:
        include ManyHelper

        attr_reader :name, :record

        def initialize(name, record)
          @name = name
          @record = record
        end

        def attachables
          []
        end

        def save
          delete_old_attachments(original_attachments)
          record.attachment_changes.delete(name)
          record.public_send(:"#{name}_storage_attachments=", [])
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
