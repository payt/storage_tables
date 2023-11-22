# frozen_string_literal: true

require "active_record"
require "active_support"
require "active_support/rails"

require "storage_tables/version"
require "storage_tables/engine"
require "storage_tables/errors"

require "marcel"

# This is the main module for the gem
module StorageTables
  extend ActiveSupport::Autoload

  autoload :Attached
  autoload :Service
end
