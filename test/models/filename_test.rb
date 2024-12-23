# frozen_string_literal: true

require "test_helper"

module StorageTables
  class FilenameTest < ActiveSupport::TestCase
    test "base" do
      assert_equal "racecar", StorageTables::Filename.new("racecar.jpg").base
      assert_equal "race.car", StorageTables::Filename.new("race.car.jpg").base
      assert_equal "racecar", StorageTables::Filename.new("racecar").base
    end

    test "extension with delimiter" do
      assert_equal ".jpg", StorageTables::Filename.new("racecar.jpg").extension_with_delimiter
      assert_equal ".jpg", StorageTables::Filename.new("race.car.jpg").extension_with_delimiter
      assert_equal "", StorageTables::Filename.new("racecar").extension_with_delimiter
    end

    test "extension without delimiter" do
      assert_equal "jpg", StorageTables::Filename.new("racecar.jpg").extension_without_delimiter
      assert_equal "jpg", StorageTables::Filename.new("race.car.jpg").extension_without_delimiter
      assert_equal "", StorageTables::Filename.new("racecar").extension_without_delimiter
    end

    test "sanitize" do
      "%$|:;/<>?*\"\t\r\n\\".each_char do |character|
        filename = StorageTables::Filename.new("foo#{character}bar.pdf")

        assert_equal "foo-bar.pdf", filename.sanitized
        assert_equal "foo-bar.pdf", filename.to_s
      end
    end

    test "sanitize transcodes to valid UTF-8" do
      { (+"\xF6").force_encoding(Encoding::ISO8859_1) => "ö",
        (+"\xC3").force_encoding(Encoding::ISO8859_1) => "Ã",
        "\xAD" => "�",
        "\xCF" => "�",
        "\x00" => "" }.each do |actual, expected|
        assert_equal expected, StorageTables::Filename.new(actual).sanitized
      end
    end

    test "strips RTL override chars used to spoof unsafe executables as docs" do
      # Would be displayed in Windows as "evilexe.pdf" due to the right-to-left
      # (RTL) override char!
      assert_equal "evil-fdp.exe", StorageTables::Filename.new("evil\u{202E}fdp.exe").sanitized
    end

    test "compare case-insensitively" do
      assert_equal StorageTables::Filename.new("foobar.pdf"), StorageTables::Filename.new("FooBar.PDF")
    end

    test "compare sanitized" do
      assert_equal StorageTables::Filename.new("foo-bar.pdf"), StorageTables::Filename.new("foo\tbar.pdf")
    end

    test "encoding to json" do
      assert_equal '"foo.pdf"', StorageTables::Filename.new("foo.pdf").to_json
      assert_equal '{"filename":"foo.pdf"}', { filename: StorageTables::Filename.new("foo.pdf") }.to_json
      assert_equal '{"filename":"foo.pdf"}', JSON.generate(filename: StorageTables::Filename.new("foo.pdf"))
    end

    test "#wrap" do
      assert_equal StorageTables::Filename.new("foo.pdf"),
                   StorageTables::Filename.wrap(StorageTables::Filename.new("foo.pdf"))
      assert_equal StorageTables::Filename.new("foo.pdf"), StorageTables::Filename.wrap("foo.pdf")
    end
  end
end
