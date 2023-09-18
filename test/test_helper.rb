# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "storage_tables"

require "minitest/autorun"

require File.expand_path("../test/dummy/config/environment.rb", __dir__)
ENV["RAILS_ROOT"] ||= "#{File.dirname(__FILE__)}../../../test/dummy"
