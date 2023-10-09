# frozen_string_literal: true

module StorageTables
  # Representation of a file with the location of the file stored in a database table.
  class Blob < ApplicationRecord
    include ActiveStorage::Blob::Identifiable

    # Need to set a primary key because active_record want to order by the primary key, although there is none
    # We can consider checksum as a primary key, but its uniqueness is guaranteed.
    self.primary_key = :checksum

    # Use this method because triggers are not supported in PostgreSQL until version 13
    before_create -> { self.partition_key = checksum[0] }

    store :metadata, accessors: [:analyzed, :identified, :mtime, :filename], coder: ActiveRecord::Coders::JSON

    class_attribute :services, default: {}
    class_attribute :service, instance_accessor: false
    class_attribute :service_name

    has_many :attachments, class_name: "StorageTables::Attachment", foreign_key: :checksum, primary_key: :checksum,
                           dependent: :restrict_with_exception, inverse_of: :blob

    validates :checksum, presence: true

    after_initialize do
      self.service_name ||= self.class.service.name
    end

    class << self
      def build_after_unfurling(io:, filename:, content_type: nil, metadata: nil, identify: true)
        new(filename: filename, content_type: content_type, metadata: metadata).tap do |blob|
          blob.unfurl(io, identify: identify)
        end
      end

      def create_after_unfurling!(io:, filename:, content_type: nil, metadata: nil, identify: true)
        build_after_unfurling(io: io, filename: filename, content_type: content_type, metadata: metadata,
                              identify: identify).tap(&:save!)
      end

      # Creates a new blob instance and then uploads the contents of
      # the given <tt>io</tt> to the service. The blob instance is going to
      # be saved before the upload begins to prevent the upload clobbering another due to key collisions.
      # When providing a content type, pass <tt>identify: false</tt> to bypass
      # automatic content type inference.
      def create_and_upload!(io:, filename:, content_type: nil, metadata: nil, identify: true)
        create_after_unfurling!(io: io, filename: filename, content_type: content_type, metadata: metadata,
                                identify: identify).tap do |blob|
          blob.upload_without_unfurling(io)
        end
      end

      def existing_blob(io)
        find_by(partition_key: computed_checksum(io)[0], checksum: computed_checksum(io))
      end
    end

    def unfurl(io, identify: true)
      self.checksum = computed_checksum(io)
      self.partition_key = checksum[0]
      self.content_type = extract_content_type(io) if content_type.nil? || identify
      self.byte_size    = io.size
      self.identified   = true
    end

    def upload_without_unfurling(io)
      service.upload checksum, io, checksum: checksum, **service_metadata
    end

    # Downloads the file associated with this blob. If no block is given,
    # the entire file is read into memory and returned.
    # That'll use a lot of RAM for very large files. If a block is given,
    # then the download is streamed and yielded in chunks.
    def download(&block)
      service.download checksum, &block
    end

    # Returns an instance of service, which can be configured globally or per attachment
    def service
      services.fetch(service_name)
    end

    private

    def computed_checksum(io)
      @computed_checksum ||= compute_checksum_in_chunks(io)
    end

    def compute_checksum_in_chunks(io)
      OpenSSL::Digest.new("SHA3-512").tap do |checksum|
        while (chunk = io.read(5.megabytes))
          checksum << chunk
        end

        io.rewind
      end.base64digest
    end

    def extract_content_type(io)
      Marcel::MimeType.for io, name: filename.to_s, declared_type: content_type
    end

    def forcibly_serve_as_binary?
      ActiveStorage.content_types_to_serve_as_binary.include?(content_type)
    end

    def allowed_inline?
      ActiveStorage.content_types_allowed_inline.include?(content_type)
    end

    def web_image?
      ActiveStorage.web_image_content_types.include?(content_type)
    end

    def service_metadata
      if forcibly_serve_as_binary?
        { content_type: ActiveStorage.binary_content_type, disposition: :attachment, filename: filename }
      elsif !allowed_inline?
        { content_type: content_type, disposition: :attachment, filename: filename }
      else
        { content_type: content_type }
      end
    end
  end
end

ActiveSupport.run_load_hooks :storage_tables_blob, StorageTables::Blob
