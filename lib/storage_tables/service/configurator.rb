# frozen_string_literal: true

module StorageTables
  module Service
    class Configurator < ActiveStorage::Service::Configurator
      private

      def resolve(class_name)
        raise StorageTables::ServiceError "Only disk is usable for storage tables" unless class_name.to_s == "Disk"

        require "storage_tables/service/#{class_name.to_s.underscore}_service"
        StorageTables::Service.const_get(:"#{class_name.camelize}Service")
      rescue LoadError
        raise "Missing service adapter for #{class_name.inspect}"
      end
    end
  end
end
