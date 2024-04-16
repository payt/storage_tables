# frozen_string_literal: true

require "active_record/reflection"

module StorageTables
  # Storage Tables reflection extensions for Active Record.
  module Reflection
    include ActiveStorage::Reflection
    # Holds all the metadata about a has_one_attached attachment as it was
    # specified in the Active Record class.
    class StoredOneAttachmentReflection < ActiveRecord::Reflection::MacroReflection # :nodoc:
      def macro
        :stored_one_attachment
      end
    end

    # Holds all the metadata about a has_many_attached attachment as it was
    # specified in the Active Record class.
    class StoredManyAttachmentsReflection < ActiveRecord::Reflection::MacroReflection # :nodoc:
      def macro
        # TODO: Cover many attachments in other PR
        # :nocov:
        :stored_many_attachments
        # :nocov:
      end
    end

    module ReflectionExtension # :nodoc:
      def add_attachment_reflection(model, name, reflection)
        model.attachment_reflections = model.attachment_reflections.merge(name.to_s => reflection)
      end

      private

      def reflection_class_for(macro)
        case macro
        when :stored_one_attachment
          StoredOneAttachmentReflection
        # :nocov:
        when :stored_many_attachments
          StoredManyAttachmentsReflection
        # :nocov:
        else
          super
        end
      end
    end
  end
end
