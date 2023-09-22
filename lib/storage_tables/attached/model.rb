# frozen_string_literal: true

module StorageTables
  module Attached::Model
    extend ActiveSupport::Concern

    class_methods do
      def stored_one_attachment(name, class_name:)
        define_method(name) do
          @storage_tables_attached ||= {}
          @storage_tables_attached[name.to_sym] ||= ActiveStorage::Attached::One.new(name.to_s, self)
        end

        define_method("#{name}=") do |attachable|
          attachment_changes["#{name}"] =
            if attachable.nil? || attachable == ""
              ActiveStorage::Attached::Changes::DeleteOne.new("#{name}", self)
            else
              ActiveStorage::Attached::Changes::CreateOne.new("#{name}", self, attachable)
            end
        end

        has_one :"#{name}_storage_attachment", lambda {
                                                 where(name: name)
                                               }, class_name: class_name, as: :record, inverse_of: :record, dependent: :destroy
        has_one :"#{name}_storage_blob", through: :"#{name}_storage_attachment", class_name: "StorageTables::Blob",
                                         source: :blob

        scope :"with_stored_#{name}", lambda {
          includes("#{name}_attachment": :blob)
        }

        after_save { attachment_changes[name.to_s]&.save }

        after_commit(on: %i[create update]) { attachment_changes.delete(name.to_s).try(:upload) }

        reflection = ActiveRecord::Reflection.create(
          :stored_one_attachment,
          name,
          nil,
          { class_name: class_name },
          self
        )
        yield reflection if block_given?
        ActiveRecord::Reflection.add_attachment_reflection(self, name, reflection)
      end
    end
  end
end
