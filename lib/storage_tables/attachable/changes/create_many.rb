# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create many attachments from an attachable blob.
      class CreateMany
        include ManyHelper

        attr_reader :name, :record, :attachables, :pending_uploads

        def initialize(name, record, attachables, pending_uploads: [])
          @name = name
          @record = record
          @attachables = Array(attachables)
          blobs.each(&:identify_without_saving)
          @pending_uploads = Array(pending_uploads) + subchanges_without_blobs
          attachments
        end

        def save
          ActiveRecord::Base.transaction do
            delete_old_attachments(removable_attachments)
            assign_associated_attachments
            reset_associated_blobs
          end
        end

        def attachments
          @attachments ||= subchanges.collect(&:attachment)
        end

        def blobs
          @blobs ||= subchanges.collect(&:blob)
        end

        private

        def subchanges
          @subchanges ||= attachables.collect { |attachable| build_subchange_from(attachable) }
        end

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

        def persisted_or_new_attachments
          attachments.select { |attachment| attachment.persisted? || attachment.new_record? }
        end
      end
    end
  end
end
