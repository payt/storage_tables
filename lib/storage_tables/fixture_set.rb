# frozen_string_literal: true

require "active_support/testing/file_fixtures"
require "active_record/secure_token"

module StorageTables
  # Fixtures are a way of organizing data that you want to test against; in
  # short, sample data.
  #
  # To learn more about fixtures, read the
  # {ActiveRecord::FixtureSet}[rdoc-ref:ActiveRecord::FixtureSet] documentation.
  #
  class FixtureSet
    include ActiveSupport::Testing::FileFixtures
  end
end
