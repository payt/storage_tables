# frozen_string_literal: true

module StorageTables
  # = Storage Tables \Attached \Many
  #
  # Decorated proxy object representing of multiple attachments to a model.
  module Attachable
    class Many < ActiveStorage::Attached::Many
      def attach(*attachables)
        record.public_send("#{name}=", blobs + attachables.flatten)
        blobs.save! && upload(attachable)

        return if record.persisted? && !record.changed? && !record.save

        record.public_send("#{name}")
      end
    end
  end
end
