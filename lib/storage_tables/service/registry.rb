# frozen_string_literal: true

require "storage_tables/service"
require "active_storage/service/registry"
require "storage_tables/service/configurator"

module StorageTables
  class Service
    class Registry # :nodoc:
      def initialize(configurations)
        @configurations = configurations.deep_symbolize_keys
        @services = {}
      end

      def fetch(name)
        services.fetch(name.to_sym) do |key|
          if configurations.include?(key)
            services[key] = configurator.build(key)
          elsif block_given?
            yield key
          else
            raise KeyError, "Missing configuration for the #{key} Storage Tables service. " \
                            "Configurations available for the #{configurations.keys.to_sentence} services."
          end
        end
      end

      private

      attr_reader :configurations, :services

      def configurator
        @configurator ||= StorageTables::Service::Configurator.new(configurations)
      end
    end
  end
end
