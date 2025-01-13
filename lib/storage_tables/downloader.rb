# frozen_string_literal: true

module StorageTables
  class Downloader # :nodoc:
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def open(checksum, verify: true, name: "StorageTables-", tmpdir: nil)
      open_tempfile(name, tmpdir) do |file|
        download checksum, file
        verify_integrity_of(file, checksum:) if verify
        yield file
      end
    end

    private

    def open_tempfile(name, tmpdir = nil)
      file = Tempfile.open(name, tmpdir)

      begin
        yield file
      ensure
        file.close!
      end
    end

    def download(checksum, file)
      file.binmode
      service.download(checksum) { |chunk| file.write(chunk) }
      file.flush
      file.rewind
    end

    def verify_integrity_of(file, checksum:)
      return if OpenSSL::Digest.new("SHA3-512").file(file).base64digest == checksum

      raise StorageTables::IntegrityError
    end
  end
end
