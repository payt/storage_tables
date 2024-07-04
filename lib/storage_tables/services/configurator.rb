# frozen_string_literal: true

require "active_storage/service"
require "active_storage/service/configurator"

module StorageTables
  module Services
    # Set the storage service to be used by Storage Tables.
    class Configurator < ActiveStorage::Service::Configurator
      private

      def resolve(class_name)
        require "storage_tables/service/#{class_name.to_s.underscore}_service"
        StorageTables::Service.const_get(:"#{class_name.camelize}Service")
      rescue LoadError
        raise "Missing service adapter for #{class_name.inspect}"
      end
    end
  end
end
