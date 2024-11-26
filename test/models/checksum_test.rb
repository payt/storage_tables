# frozen_string_literal: true

require "test_helper"

module StorageTables
  class ChecksumTest < ActiveSupport::TestCase
    test "wrap" do
      checksum = Checksum.new("1234567890")

      assert_equal checksum, Checksum.wrap(checksum)
      assert_equal checksum, Checksum.wrap("1234567890")
    end

    test "from_io" do
      io = StringIO.new("Hello world!")
      checksum = Checksum.from_io(io)

      assert_predicate checksum, :valid?
    end

    test "from_file" do
      file = file_fixture("report.pdf")
      checksum = Checksum.from_file(file)

      assert_predicate checksum, :valid?
    end

    test "from_db" do
      partition_key = "1"
      partition_checksum = "0" * 85
      checksum = Checksum.from_db(partition_key, partition_checksum)

      assert_predicate checksum, :valid?
    end
  end
end
