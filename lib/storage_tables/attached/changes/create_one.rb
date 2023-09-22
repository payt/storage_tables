module StorageTables
  class Attached::Changes::CreateOne < ActiveStorage::Attached::Changes::CreateOne
    def build_attachment
      binding.pry
    end

    def attachment_service_name
      record.attachment_reflections[name].options[:class_name]
    end
  end
end
