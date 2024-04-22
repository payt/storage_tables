# frozen_string_literal: true

module StorageTables
  # = Storage Tables \Attached \Many
  #
  # Decorated proxy object representing of multiple attachments to a model.
  module Attachable
    # Create many attachments to a model.
    class Many < ActiveStorage::Attached::Many
      include Changes::Helper

      def attach(*attachables)
        enriched_attachables(attachables)

        record.public_send(:"#{name}=", blobs + attachables.flatten)
        blobs.all?(&:save!) && upload_many(attachables)

        return if record.persisted? && !record.changed? && !record.save

        record.public_send(:"#{name}")
      end

      # Returns all the associated attachment records.
      #
      # All methods called on this proxy object that aren't listed here will automatically be delegated to +attachments+.
      def attachments
        change.present? ? change.attachments : record.public_send(:"#{name}_storage_attachments")
      end

      # Returns all attached blobs.
      def blobs
        change.present? ? change.blobs : record.public_send(:"#{name}_storage_blobs")
      end

      def upload_many(attachables)
        attachables.each { |attachable| upload(attachable) }
      end

      def enriched_attachables(attachables)
        binding.pry
      end
    end
  end
end
