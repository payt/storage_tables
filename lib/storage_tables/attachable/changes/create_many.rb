# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create many attachments from an attachable blob.
      class CreateMany < Attached::Changes::CreateMany
        def save
          ActiveRecord::Base.transaction do
            delete_old_attachments if removable_attachments.any?
            super
          end
        end

        private

        def build_subchange_from(attachable)
          StorageTables::Attachable::Changes::CreateOneOfMany.new(name, record, attachable)
        end

        def subchanges_without_blobs
          subchanges.reject { |subchange| subchange.attachable.is_a?(StorageTables::Blob) }
        end

        def assign_associated_attachments
          record.public_send(:"#{name}_storage_attachments=", persisted_or_new_attachments)
        end

        def reset_associated_blobs
          record.public_send(:"#{name}_storage_blobs").reset
        end

        def original_attachments
          record.public_send(:"#{name}_storage_attachments")
        end

        def delete_old_attachments
          klazz.where(klazz.primary_key => removable_attachments.pluck(:record_id, :blob_key, :checksum)).delete_all
        end

        def klazz
          original_attachments.first.class
        end

        def removable_attachments
          original_attachments - persisted_or_new_attachments
        end
      end
    end
  end
end
