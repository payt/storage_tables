# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Helper methods for attachable changes.
      module ManyHelper
        private

        def original_attachments
          record.public_send(:"#{name}_storage_attachments")
        end

        def attachment_class
          original_attachments.first.class
        end

        def delete_old_attachments(attachments)
          return if attachments.empty?

          attachment_class.where(attachment_class.primary_key => attachments.pluck(:record_id, :blob_key,
                                                                                   :checksum)).delete_all
        end
      end
    end
  end
end
