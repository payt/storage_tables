# frozen_string_literal: true

require "active_storage/service"
require "active_storage/service/configurator"

module StorageTables
  class Service
    # Set the storage service to be used by Storage Tables.
    class Configurator
      attr_reader :configurations

      def self.build(service_name, configurations)
        new(configurations).build(service_name)
      end

      def initialize(configurations)
        @configurations = configurations.deep_symbolize_keys
      end

      def build(service_name)
        config = config_for(service_name.to_sym)
        resolve(config.fetch(:service)).build(
          **config, name: service_name
        )
      end

      private

      def config_for(name)
        configurations.fetch name do
          raise "Missing configuration for the #{name.inspect} Storage Storage service. Configurations available for #{configurations.keys.inspect}"
        end
      end

      def resolve(class_name)
        require "storage_tables/service/#{class_name.to_s.underscore}_service"
        StorageTables::Service.const_get(:"#{class_name.camelize}Service")
      rescue LoadError
        raise "Missing service adapter for #{class_name.inspect}"
      end
    end
  end
end
