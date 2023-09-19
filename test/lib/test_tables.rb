# frozen_string_literal: true

require "test_helper"

module StorageTables
  class TestTables < Minitest::Test
    def test_that_it_has_a_version_number
      assert_nil ::StorageTables::VERSION
    end
  end
end
