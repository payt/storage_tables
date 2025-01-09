# frozen_string_literal: true

module StorageTables
  # = StorageTables \Checksum
  #
  # Calculates the checksum of a file using SHA3-512.
  # Convenience class for generating checksums and sanitizing them.
  class Checksum
    include Comparable

    attr_reader :checksum

    class << self
      # Returns a Checksum instance based on the given checksum. If the checksum is a Checksum Class, it is
      # returned unmodified. If it is a String, it is passed to StorageTables::Checksum.new.
      def wrap(checksum)
        yield(new(checksum))
      end

      def from_path(path)
        checksum = OpenSSL::Digest.new("SHA3-512").file(path).base64digest

        Checksum.new(checksum)
      end

      def from_io(io)
        Checksum.new(calculate_checksum(io))
      end

      # Calculate the checksum of the given string and return a Checksum instance.
      def from_string(string)
        Checksum.new(calculate_checksum(StringIO.new(string)))
      end

      def calculate_checksum(io)
        raise ArgumentError, "IO object must be rewindable" unless io.respond_to?(:rewind)

        OpenSSL::Digest.new("SHA3-512").tap do |checksum|
          while (chunk = io.read(5.megabytes))
            checksum << chunk
          end

          io.rewind
        end.base64digest
      end
    end

    def initialize(input)
      @checksum = case input
                  when self.class
                    input.to_s
                  when Array
                    determine_checksum_from_string(input.join)
                  when String
                    determine_checksum_from_string(input)
                  else
                    raise ArgumentError, "Invalid checksum: #{input.inspect}"
      end
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

    private

    def determine_checksum_from_string(checksum)
      if checksum.match?(%r{\A[A-Za-z0-9\/+]{86}==\z})
        checksum
      elsif checksum.match?(%r{\A[A-Za-z0-9\/+]{86}\z})
        "#{checksum}=="
      else
        raise ArgumentError, "Invalid checksum: #{checksum}"
      end
    end
  end
end
