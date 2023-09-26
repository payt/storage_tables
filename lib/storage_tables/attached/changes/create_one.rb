# frozen_string_literal: true

module StorageTables
  module Attached
    module Changes
      class CreateOne < ActiveStorage::Attached::Changes::CreateOne
        def build_attachment
          binding.pry
        end

        def attachment_service_name
          record.attachment_reflections[name].options[:class_name]
        end
      end
    end
  end
end
