# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes
      # Class used to create one attachment for a one-of-many association.
      class CreateOneOfMany < Attachable::Changes::CreateOne
        def initialize(name, record, attachable)
          if attachable.is_a?(Array)
            extracted_attachable = attachable.first
            extracted_filename = attachable.second
          end

          super(name, record, extracted_attachable || attachable, extracted_filename)
        end

        private

        def find_attachment
          record.public_send(:"#{name}_storage_attachments").detect { |attachment| attachment.blob == blob }
        end
      end
    end
  end
end
