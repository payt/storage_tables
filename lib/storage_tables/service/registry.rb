# frozen_string_literal: true

require "storage_tables/service/configurator"

module StorageTables
  module Service
    # A registry for storage services that are configured in the application.
    class Registry
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
