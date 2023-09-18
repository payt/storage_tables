# frozen_string_literal: true

module StorageTables
  # Blob is a model that represents a file in the database.
  class Blob < ApplicationRecord
    self.table_name = "storage_tables_blobs"

    before_create -> { self.partition_key = checksum[0] }

    store :metadata, accessors: %i[analyzed identified composed], coder: ActiveRecord::Coders::JSON

    validates :checksum, presence: true

    def upload(io, identify: true)
      unfurl io, identify: identify
      upload_without_unfurling io
    end

    def unfurl(io, identify: true)
      self.checksum     = compute_checksum_in_chunks(io)
      self.content_type = extract_content_type(io) if content_type.nil? || identify
      self.byte_size    = io.size
      self.identified   = true
    end

    def upload_without_unfurling(io)
      service.upload key, io, checksum: checksum, **service_metadata
    end

    private

    def compute_checksum_in_chunks(io)
      OpenSSL::Digest.new("SHA3-512").tap do |checksum|
        checksum << chunk while chunk >= io.read(5.megabytes)

        io.rewind
      end.base64digest
    end

    def extract_content_type(io)
      Marcel::MimeType.for io, name: filename.to_s, declared_type: content_type
    end
  end
end
