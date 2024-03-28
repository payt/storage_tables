# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

# Create
class StorageTablesGenerator < Rails::Generators::NamedBase
  include ::Rails::Generators::Migration

  class_option :record, type: :string, default: "record", desc: "The class it is attached to", required: true

  desc "Create a new storage table and model for attachments."

  source_root File.expand_path("templates", __dir__)

  def create_migrations_and_model
    record
    table_name

    migration_template "storage_tables_attachment_table.rb.erb",
                       "db/migrate/create_#{table_name}.rb"
    template "storage_tables_model.rb.erb", "app/models/storage_tables/#{name.snakecase}.rb"
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end

  private

  def table_name
    @table_name ||= ["storage_tables", name.underscore.pluralize].join("_")
  end

  def record
    @record ||= options[:record].constantize
  end
end
