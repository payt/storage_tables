# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteOne < ActiveStorage::Attached::Changes::DeleteOne # :nodoc:
        def save
          record.public_send(:"#{name}_storage_attachment")&.delete
          record.attachment_changes.delete(name)
          record.public_send(:"#{name}_storage_attachment=", nil)
        end
      end
    end
  end
end
