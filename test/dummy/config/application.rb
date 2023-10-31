# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "active_storage/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "storage_tables"

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0

    config.active_record.schema_format = :sql
    config.active_storage.service = :local

    config.storage_tables.service = :local
  end
end
