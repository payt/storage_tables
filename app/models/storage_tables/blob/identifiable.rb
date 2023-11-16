# frozen_string_literal: true

module StorageTables
  module Blob::Identifiable
    include ActiveStorage::Blob::Identifiable

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
