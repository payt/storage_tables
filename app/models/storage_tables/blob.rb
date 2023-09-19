# frozen_string_literal: true

module StorageTables
  class Blob < ApplicationRecord
    before_create -> { self.partition_key = checksum[0] }

    store :metadata, accessors: %i[analyzed identified uploaded], coder: ActiveRecord::Coders::JSON

    class_attribute :services, default: {}
    class_attribute :service, instance_accessor: false

    validates :checksum, presence: true

    class << self
      def build_after_unfurling(io:, filename:, content_type: nil, metadata: nil, identify: true, record: nil)
        new(filename: filename, content_type: content_type, metadata: metadata).tap do |blob|
          blob.unfurl(io, identify: identify)
        end
      end

      def create_after_unfurling!(io:, filename:, content_type: nil, metadata: nil, identify: true,
                                  record: nil)
        build_after_unfurling(io: io, filename: filename, content_type: content_type, metadata: metadata,
                              identify: identify).tap(&:save!)
      end

      # Creates a new blob instance and then uploads the contents of
      # the given <tt>io</tt> to the service. The blob instance is going to
      # be saved before the upload begins to prevent the upload clobbering another due to key collisions.
      # When providing a content type, pass <tt>identify: false</tt> to bypass
      # automatic content type inference.
      def create_and_upload!(io:, filename:, content_type: nil, metadata: nil, identify: true, record: nil)
        create_after_unfurling!(io: io, filename: filename, content_type: content_type, metadata: metadata,
                                identify: identify).tap do |blob|
          blob.upload_without_unfurling(io)
        end
      end
    end

    def upload(io, identify: true)
      unfurl io, identify: identify
      upload_without_unfurling io
    end

    def unfurl(io, identify: true)
      self.checksum = compute_checksum_in_chunks(io)
      self.content_type = extract_content_type(io) if content_type.nil? || identify
      self.byte_size    = io.size
      self.identified   = true
    end

    def upload_without_unfurling(io)
      service.upload key, io, checksum: checksum, **service_metadata
    end

    # Returns an instance of service, which can be configured globally or per attachment
    def service
      services.fetch(service_name)
    end

    private

    def compute_checksum_in_chunks(io)
      OpenSSL::Digest.new("SHA3-512").tap do |checksum|
        while chunk = io.read(5.megabytes)
          checksum << chunk
        end

        io.rewind
      end.base64digest
    end

    def extract_content_type(io)
      Marcel::MimeType.for io, name: filename.to_s, declared_type: content_type
    end
  end
end

ActiveSupport.run_load_hooks :storage_tables_blob, StorageTables::Blob
