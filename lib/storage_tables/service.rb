# frozen_string_literal: true

module StorageTables
  # Loads and configures the Storage service to be used to store files.
  class Service
    extend ActiveSupport::Autoload
    autoload StorageTables::Service::Configuraator

    class << self
      # Configure an Active Storage service by name from a set of configurations,
      # typically loaded from a YAML file. The Active Storage engine uses this
      # to set the global Active Storage service when the app boots.
      def configure(service_name, configurations)
        StorageTables::Service::Configurator.build(service_name, configurations)
      end
    end
  end
end
