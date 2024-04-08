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
                # TODO: Cover deleting attachments later.
                StorageTables::Attachable::Changes::DeleteOne.new(name.to_s, self)
              else
                StorageTables::Attachable::Changes::CreateOne.new(name.to_s, self, attachable, filename)
              end
          end

          has_one :"#{name}_storage_attachment", class_name: class_name.to_s, inverse_of: :record,
                                                 foreign_key: :record_id, dependent: :destroy
          has_one :"#{name}_storage_blob", through: :"#{name}_storage_attachment", class_name: "StorageTables::Blob",
                                           source: :blob

          scope :"with_stored_#{name}", lambda {
            includes("#{name}_storage_attachment": :blob)
          }

          after_save { attachment_changes[name.to_s]&.save }

          reflection = ActiveRecord::Reflection.create(
            :stored_one_attachment,
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
