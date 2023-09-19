# frozen_string_literal: true

module StorageTables
  class Engine < ::Rails::Engine
    isolate_namespace StorageTables

    initializer "storage_tables.services" do
      ActiveSupport.on_load(:storage_tables_blob) do
        # Use the application's configured Active Storage service.
        configs = Rails.configuration.active_storage.service_configurations ||=
          begin
            config_file = Rails.root.join("config/storage/#{Rails.env}.yml")
            config_file = Rails.root.join("config/storage.yml") unless config_file.exist?
            raise("Couldn't find Active Storage configuration in #{config_file}") unless config_file.exist?

            ActiveSupport::ConfigurationFile.parse(config_file)
          end

        StorageTables::Blob.services = StorageTables::Service::Registry.new(configs)

        if config_choice = Rails.configuration.active_storage.service
          StorageTables::Blob.service = StorageTables::Blob.services.fetch(config_choice)
        end
      end
    end
  end
end
