# frozen_string_literal: true

require "rails"
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

  # Set to at least 1 for tests, because all tests are wrapped in a transaction.
  MAX_TRANSACTIONS_OPEN = Rails.env.test? ? 1 : 0

  autoload :Attached
  autoload :Service

  mattr_accessor :verifier

  mattr_accessor :routes_prefix, default: "/rails/storage_tables"
  mattr_accessor :draw_routes, default: true

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("0.2.0", "StorageTables")
  end
end
