# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create many attachments from an attachable blob.
      class CreateMany < Attached::Changes::CreateMany
        include ManyHelper

        def save
          ActiveRecord::Base.transaction do
            delete_old_attachments(removable_attachments)
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

        def removable_attachments
          original_attachments - persisted_or_new_attachments
        end
      end
    end
  end
end
