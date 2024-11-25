# frozen_string_literal: true

module StorageTables
  # Convenience class for generating checksums
  class Checksum
    def self.generate(io)
      OpenSSL::Digest.new("SHA3-512").tap do |checksum|
        while (chunk = io.read(5.megabytes))
          checksum << chunk
        end

        io.rewind
      end.base64digest
    end

    def self.generate_safe(io)
      checksum = generate(io)
      checksum.tr("/+", "_-")
    end
  end
end
