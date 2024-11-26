# frozen_string_literal: true

module StorageTables
  # = StorageTables \Checksum
  #
  # Calculates the checksum of a file using SHA3-512.
  # Convenience class for generating checksums and sanitizing them.
  class Checksum
    include Comparable
    include ActiveModel::Validations

    attr_reader :checksum, :io

    validates :checksum, presence: true
    validates :checksum, length: { is: 88 }

    def initialize(io: nil, checksum: nil)
      io = StringIO.new(io) if io.is_a?(String)

      if io
        @io = io
        @checksum = calculate_checksum(io)
      end
      @checksum = checksum if checksum
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
end
