# frozen_string_literal: true

require "storage_tables"
require "storage_tables/service/registry"

require "storage_tables/reflection"

module StorageTables
  # This class is used to hook into Rails
  class Engine < ::Rails::Engine
    isolate_namespace StorageTables

    initializer "storage_tables.attached" do
      require "storage_tables/attached"

      ActiveSupport.on_load(:active_record) do
        include StorageTables::Attachable::Model
      end
    end

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

        if (config_choice = Rails.configuration.active_storage.service)
          StorageTables::Blob.service = StorageTables::Blob.services.fetch(config_choice)
        end
      end
    end

    initializer "active_storage.reflection" do
      ActiveSupport.on_load(:active_record) do
        include Reflection::ActiveRecordExtensions
        ActiveRecord::Reflection.singleton_class.prepend(Reflection::ReflectionExtension)
      end
    end
  end
end
