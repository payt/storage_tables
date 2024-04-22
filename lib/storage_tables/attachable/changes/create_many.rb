# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create many attachments from an attachable blob.
      class CreateMany < Attached::Changes::CreateMany
        private

        def build_subchange_from(attachable)
          StorageTables::Attachable::Changes::CreateOneOfMany.new(name, record, attachable, filename)
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
      end
    end
  end
end
