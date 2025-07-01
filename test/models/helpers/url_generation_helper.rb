# frozen_string_literal: true

module StorageTables
  module Helpers
    module UrlGenerationHelper
      def expected_url_for(blob, disposition: :attachment, filename: nil, content_type: nil, service_name: :local)
        content_type ||= blob.content_type
        content_disposition = ActionDispatch::Http::ContentDisposition.format(disposition: disposition,
                                                                              filename: filename.sanitized)

        key_params = { checksum: blob.checksum,
                       disposition: content_disposition, content_type: content_type, service_name: service_name }

        "https://example.com/rails/storage_tables/disk/#{StorageTables.verifier.generate(key_params,
                                                                                         expires_in: 15.minutes,
                                                                                         purpose: :blob_url)}/#{filename}"
      end
    end
  end
end
