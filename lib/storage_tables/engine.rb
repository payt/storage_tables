# frozen_string_literal: true

require "rails/engine"

require "storage_tables"

require "storage_tables/service/registry"
require "storage_tables/reflection"

module StorageTables
  # This class is used to hook into Rails
  class Engine < ::Rails::Engine
    isolate_namespace StorageTables

    config.storage_tables = ActiveSupport::OrderedOptions.new

    initializer "storage_tables.attached" do
      require "storage_tables/attached"

      ActiveSupport.on_load(:active_record) do
        include StorageTables::Attachable::Model
      end
    end

    initializer "storage_tables.verifier" do
      config.after_initialize do |app|
        StorageTables.verifier = app.message_verifier("StorageTables")
      end
    end

    initializer "storage_tables.configs" do
      config.after_initialize do |app|
        StorageTables.routes_prefix = app.config.storage_tables.routes_prefix || "/rails/storage_tables"
      end
    end

    initializer "storage_tables.services" do
      ActiveSupport.on_load(:storage_tables_blob) do
        # Use the application's configured Active Storage service.
        configs = Rails.configuration.active_storage.service_configurations
        StorageTables::Blob.services = StorageTables::Service::Registry.new(configs)

        config_choice = Rails.configuration.storage_tables.service
        StorageTables::Blob.service = StorageTables::Blob.services.fetch(config_choice)
      end
    end

    initializer "storage_tables.reflection" do
      ActiveSupport.on_load(:active_record) do
        include Reflection::ActiveRecordExtensions
        ActiveRecord::Reflection.singleton_class.prepend(Reflection::ReflectionExtension)
      end
    end
  end
end
