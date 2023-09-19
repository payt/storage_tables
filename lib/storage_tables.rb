# frozen_string_literal: true

require "active_record"
require "active_support"
require "active_support/rails"

require "storage_tables/version"
require "storage_tables/engine"

require "marcel"

module StorageTables
  extend ActiveSupport::Autoload

  autoload :Service

  # Your code goes here...
end
