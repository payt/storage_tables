# frozen_string_literal: true

module StorageTables
  # Base attachment class for all attachments.
  class Attachment < ApplicationRecord
    self.abstract_class = true

    # Columns StorageTables derives itself from the record and the blob it was handed. They are
    # stripped from permitted_attachment_attributes even when a subclass lists them: an
    # attachment's filename, and its link to a record and a blob, are never the caller's to set.
    RESERVED_ATTACHMENT_ATTRIBUTES = [:blob, :blob_key, :checksum, :filename, :record,
                                      :record_id].freeze

    # Backs permitted_attachment_attributes. Assign through that, so the reserved columns above are
    # stripped; this holds what survived.
    class_attribute :declared_attachment_attributes, instance_accessor: false, default: [].freeze

    belongs_to :blob, class_name: "StorageTables::Blob", autosave: true, foreign_key: [:checksum, :blob_key]

    delegate :byte_size, :content_type, to: :blob

    validates :filename, presence: true

    def download
      association(:blob).klass.service.download(full_checksum)
    end

    def path
      association(:blob).klass.service.path_for(full_checksum)
    end

    def relative_path
      association(:blob).klass.service.relative_path_for(full_checksum)
    end

    def url(expires_in: StorageTables.service_urls_expire_in, disposition: :inline)
      blob.url(filename: filename, disposition: disposition, expires_in: expires_in)
    end

    def open(**args, &)
      blob.open(filename: filename.extension_with_delimiter, **args, &)
    end

    def full_checksum
      raise StorageTables::ActiveRecordError, "blob is nil" unless checksum

      "#{blob_key}#{checksum}=="
    end

    # Returns an StorageTables::Filename instance of the filename that can be
    # queried for basename, extension, and a sanitized version of the filename
    # that's safe to use in URLs.
    def filename
      StorageTables::Filename.new(self[:filename])
    end

    class << self
      # Columns that may be set through the attachable Hash's :attachment_attributes key.
      #
      # An attachment table is owned by the application, so StorageTables cannot know which of its
      # columns are safe to write from whatever built the attachable. Nothing is writable until a
      # subclass says so, and anything not listed is dropped rather than rejected.
      #
      #   class InvoiceDocument < StorageTables::Attachment
      #     self.permitted_attachment_attributes = [:template_name]
      #   end
      def permitted_attachment_attributes
        declared_attachment_attributes
      end

      def permitted_attachment_attributes=(names)
        self.declared_attachment_attributes = (names.map(&:to_sym) - RESERVED_ATTACHMENT_ATTRIBUTES).freeze
      end

      def find_by_checksum(checksum)
        find_by(blob_key: checksum[0], checksum: checksum[1..].chomp("=="))
      end

      def find_by_checksum!(checksum)
        find_by!(blob_key: checksum[0], checksum: checksum[1..].chomp("=="))
      end

      def where_checksum(input)
        if input.is_a?(Array)
          where([:blob_key, :checksum] => input.map { checksum_to_primary(_1) })
        else
          where(blob_key: input[0], checksum: input[1..].chomp("=="))
        end
      end

      private

      # Cut the checksum into an Array to match the primary key
      def checksum_to_primary(checksum)
        [checksum[0], checksum[1..].chomp("==")]
      end
    end
  end
end
