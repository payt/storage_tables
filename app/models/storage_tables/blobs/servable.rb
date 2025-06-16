# frozen_string_literal: true

module StorageTables
  module Blobs
    module Servable # :nodoc:
      def content_type_for_serving
        forcibly_serve_as_binary? ? StorageTables.binary_content_type : content_type
      end

      def forced_disposition_for_serving
        return :attachment if forcibly_serve_as_binary? || !allowed_inline?

        nil
      end

      private

      def forcibly_serve_as_binary?
        StorageTables.content_types_to_serve_as_binary.include?(content_type)
      end

      def allowed_inline?
        StorageTables.content_types_allowed_inline.include?(content_type)
      end
    end
  end
end
