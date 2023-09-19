# frozen_string_literal: true

module StorageTables
  module Service
    class Configurator < ActiveStorage::Service::Configurator
      private

      def resolve(class_name)
        binding.pry
        if class_name.to_s == "Disk"
          require "storage_tables/service/#{class_name.to_s.underscore}_service"
          StorageTables::Service.const_get(:"#{class_name.camelize}Service")
        else
          require "active_storage/service/#{class_name.to_s.underscore}_service"
          ActiveStorage::Service.const_get(:"#{class_name.camelize}Service")
        end
      rescue LoadError
        raise "Missing service adapter for #{class_name.inspect}"
      end
    end
  end
end
