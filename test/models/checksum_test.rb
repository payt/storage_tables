# frozen_string_literal: true

require "test_helper"

module StorageTables
  class ChecksumTest < ActiveSupport::TestCase
    test "wrap" do
      Checksum.wrap("0" * 86) do |checksum|
        assert_equal checksum, Checksum.new(checksum)
        assert_equal checksum, Checksum.new("0" * 86)
      end
    end

    test "from_io" do
      io = StringIO.new("Hello world!")
      checksum = Checksum.from_io(io)

      assert_predicate checksum, :valid?
    end

    test "from_path" do
      file = file_fixture("report.pdf")
      checksum = Checksum.from_path(file)

      assert_predicate checksum, :valid?
    end

    test "from_array" do
      partition_key = "1"
      partition_checksum = "0" * 85
      checksum = Checksum.new([partition_key, partition_checksum])

      assert_predicate checksum, :valid?
    end
    test "when initialized with checksum like string" do
      string = ("0" * 86) << "==" # 86 characters + 2 padding
      checksum = Checksum.new(string)

      assert_predicate checksum, :valid?
      assert_equal checksum.to_s, string
    end

    test "when initialized with checksum like string without padding" do
      string = "0" * 86 # 86 characters
      checksum = Checksum.new(string)

      assert_predicate checksum, :valid?
      assert_equal checksum.to_s, "#{string}=="
    end

    test "when initialized with nil value" do
      error = assert_raises(ArgumentError) { Checksum.new(nil) }

      assert_equal "Invalid checksum: nil", error.message
    end

    test "when initialized with invalid checksum" do
      error = assert_raises(ArgumentError) { Checksum.new("invalid") }

      assert_equal "Invalid checksum: invalid", error.message
    end
  end
end
