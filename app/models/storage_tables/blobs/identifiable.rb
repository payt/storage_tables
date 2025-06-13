# frozen_string_literal: true

module StorageTables
  module Blobs
    # Identify the content type of a blob.
    module Identifiable
      def identify_without_saving
        return if identified?

        self.content_type = identify_content_type
        self.identified = true
      end

      def identified?
        identified
      end

      private

      def identify_content_type
        Marcel::MimeType.for download_identifiable_chunk, declared_type: content_type
      end

      def download_identifiable_chunk
        if byte_size.positive?
          service.download_chunk checksum, 0...(4.kilobytes)
        else
          ""
        end
      end
    end
  end
end
