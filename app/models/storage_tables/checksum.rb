# frozen_string_literal: true

module StorageTables
  # = StorageTables \Checksum
  #
  # Calculates the checksum of a file using SHA3-512.
  # Convenience class for generating checksums and sanitizing them.
  class Checksum
    include Comparable
    include ActiveModel::Validations

    attr_reader :checksum

    validates :checksum, presence: true
    validates :checksum, length: { is: 88 }

    class << self
      # Returns a Checksum instance based on the given checksum. If the checksum is a Checksum Class, it is
      # returned unmodified. If it is a String, it is passed to StorageTables::Checksum.new.
      def wrap(checksum)
        checksum.is_a?(self) ? checksum : new(checksum)
      end

      def from_io(io)
        io = StringIO.new(io) if io.is_a?(String)
        checksum = calculate_checksum(io)

        new(checksum)
      end

      def from_file(path)
        checksum = OpenSSL::Digest.new("SHA3-512").file(path).base64digest

        new(checksum)
      end

      def from_db(partition_key, partition_checksum)
        new("#{partition_key}#{partition_checksum}==")
      end

      private

      def calculate_checksum(io)
        OpenSSL::Digest.new("SHA3-512").tap do |checksum|
          while (chunk = io.read(5.megabytes))
            checksum << chunk
          end

          io.rewind
        end.base64digest
      end
    end

    def initialize(checksum)
      @checksum = checksum
    end

    # Returns the checksum
    def to_s
      checksum
    end

    # Returns the checksum with / and + replaced with _ and - respectively.
    # This is useful for using the checksum in URLs and saving it to disk.
    def sanitized
      checksum.tr("/+", "_-")
    end

    def <=>(other)
      sanitized.downcase <=> other.sanitized.downcase
    end

    def partition_key
      checksum[0]
    end

    def partition_checksum
      checksum[1..].chomp("==")
    end
  end
end
