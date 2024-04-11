# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      class DeleteOne < ActiveStorage::Attached::Changes::DeleteOne # :nodoc:
        def save
          record.public_send(:"#{name}_storage_attachment").delete
        end
      end
    end
  end
end
