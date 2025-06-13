# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteOne # :nodoc:
        attr_reader :name, :record

        def initialize(name, record)
          @name = name
          @record = record
        end

        def attachment
          nil
        end

        def save
          record.public_send(:"#{name}_storage_attachment")&.delete
          record.attachment_changes.delete(name)
          record.public_send(:"#{name}_storage_attachment=", nil)
        end
      end
    end
  end
end
