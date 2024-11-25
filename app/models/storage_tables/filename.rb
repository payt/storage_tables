# frozen_string_literal: true

module StorageTables
    # = StorageTables \Filename
    #
    # Encapsulates a string representing a filename to provide convenient access to parts of it and sanitization.
    # A Filename instance is returned by StorageTables::Blob#filename, and is comparable so it can be used for sorting.
  class Filename
    include Comparable

    class << self
      # Returns a Filename instance based on the given filename. If the filename is a Filename, it is
      # returned unmodified. If it is a String, it is passed to StorageTables::Filename.new.
      def wrap(filename)
        filename.is_a?(self) ? filename : new(filename)
      end
    end

    def initialize(filename)
      @filename = filename
    end

    # Returns the part of the filename preceding any extension.
    #
    #   StorageTables::Filename.new("racecar.jpg").base # => "racecar"
    #   StorageTables::Filename.new("racecar").base     # => "racecar"
    #   StorageTables::Filename.new(".gitignore").base  # => ".gitignore"
    def base
      File.basename @filename, extension_with_delimiter
    end

    # Returns the extension of the filename (i.e. the substring following the last dot, excluding a dot at the
    # beginning) with the dot that precedes it. If the filename has no extension, an empty string is returned.
    #
    #   StorageTables::Filename.new("racecar.jpg").extension_with_delimiter # => ".jpg"
    #   StorageTables::Filename.new("racecar").extension_with_delimiter     # => ""
    #   StorageTables::Filename.new(".gitignore").extension_with_delimiter  # => ""
    def extension_with_delimiter
      File.extname @filename
    end

    # Returns the extension of the filename (i.e. the substring following the last dot, excluding a dot at
    # the beginning). If the filename has no extension, an empty string is returned.
    #
    #   StorageTables::Filename.new("racecar.jpg").extension_without_delimiter # => "jpg"
    #   StorageTables::Filename.new("racecar").extension_without_delimiter     # => ""
    #   StorageTables::Filename.new(".gitignore").extension_without_delimiter  # => ""
    def extension_without_delimiter
      extension_with_delimiter.from(1).to_s
    end

    alias extension extension_without_delimiter

    # Returns the sanitized filename.
    #
    #   StorageTables::Filename.new("foo:bar.jpg").sanitized # => "foo-bar.jpg"
    #   StorageTables::Filename.new("foo/bar.jpg").sanitized # => "foo-bar.jpg"
    #
    # Characters considered unsafe for storage (e.g. \, $, and the RTL override character) are replaced with a dash.
    def sanitized
      @filename.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�").strip.tr(
        "\u{202E}%$|:;/<>?*\"\t\r\n\\", "-"
      )
    end

    # Returns the sanitized version of the filename.
    delegate :to_s, to: :sanitized

    def as_json(*)
      to_s
    end

    def <=>(other)
      to_s.downcase <=> other.to_s.downcase
    end
  end
end
