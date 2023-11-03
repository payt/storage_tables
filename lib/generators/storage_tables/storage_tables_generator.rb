# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

class VersionsGenerator < Rails::Generators::NamedBase
  include ::Rails::Generators::Migration

  desc "Generates model class and migrations needed for a versioning table for a specific model."

  source_root File.expand_path("templates", __dir__)

  def copy_versions_migration
    model
    table_name
    namespace
    @versioned_model_primary_key_type = model.columns_hash[model.primary_key].type

    migration_template "versions_create_table.rb.erb", "db/migrate/create_#{singular_table_name}_attachments.rb"
    template "versions_model_template.rb.erb", "app/models/#{table_name}/version.rb"
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end

  private

  def model
    @model ||= class_name.constantize
  end

  def table_name
    @table_name ||= model.table_name
  end
end
