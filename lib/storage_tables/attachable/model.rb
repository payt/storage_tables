# frozen_string_literal: true

module StorageTables
  module Attachable
    # Methods for adding attachments to a model.
    module Model
      extend ActiveSupport::Concern

      class_methods do # rubocop:disable Metrics/BlockLength
        def stored_one_attachment(name, class_name:)
          define_method(name) do
            @storage_tables_attached ||= {}
            @storage_tables_attached[name.to_sym] ||= StorageTables::Attachable::One.new(name.to_s, self)
          end

          define_method(:"#{name}=") do |attachable, filename = nil|
            attachment_changes[name.to_s] =
              if attachable.nil? || attachable == ""
                StorageTables::Attachable::Changes::DeleteOne.new(name.to_s, self)
              else
                StorageTables::Attachable::Changes::CreateOne.new(name.to_s, self, attachable, filename)
              end
          end

          has_one :"#{name}_storage_attachment", class_name: class_name.to_s, inverse_of: :record,
                                                 foreign_key: :record_id
          has_one :"#{name}_storage_blob", through: :"#{name}_storage_attachment", class_name: "StorageTables::Blob",
                                           source: :blob

          scope :"with_storage_#{name}", -> { includes(:"#{name}_storage_attachment") }

          before_save { attachment_changes[name.to_s]&.save }
          after_commit(on: [:create, :update]) { attachment_changes.delete(name.to_s) }

          reflection = ActiveRecord::Reflection.create(
            :stored_one_attachment,
            name,
            nil,
            { class_name: },
            self
          )
          ActiveRecord::Reflection.add_attachment_reflection(self, name, reflection)
        end

        def stored_many_attachments(name, class_name:)
          define_method(name) do
            @storage_tables_attached ||= {}
            @storage_tables_attached[name.to_sym] ||= StorageTables::Attachable::Many.new(name.to_s, self)
          end

          define_method(:"#{name}=") do |attachables|
            attachables = Array(attachables).compact_blank
            pending_uploads = attachment_changes[name.to_s].try(:pending_uploads)

            attachment_changes[name.to_s] = if attachables.none?
              StorageTables::Attachable::Changes::DeleteMany.new(name.to_s, self)
            else
              StorageTables::Attachable::Changes::CreateMany.new(name.to_s, self, attachables, pending_uploads:)
            end
          end

          has_many(:"#{name}_storage_attachments", class_name: class_name.to_s, inverse_of: :record,
                                                   foreign_key: :record_id)
          has_many(:"#{name}_storage_blobs", through: :"#{name}_storage_attachments",
                                             class_name: "StorageTables::Blob", source: :blob)

          scope :"with_storage_#{name}", -> { includes(:"#{name}_storage_attachments") }

          after_save { attachment_changes[name.to_s]&.save }

          reflection = ActiveRecord::Reflection.create(
            :stored_many_attachments,
            name,
            nil,
            { class_name: },
            self
          )
          ActiveRecord::Reflection.add_attachment_reflection(self, name, reflection)
        end
      end
    end
  end
end
