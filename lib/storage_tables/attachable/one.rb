# frozen_string_literal: true

module StorageTables
  module Attachable
    # Representation of a single attachment to a model.
    class One < ActiveStorage::Attached::One
      # Attaches an +attachable+ to the record.
      #
      # If the record is persisted and unchanged, the attachment is saved to
      # the database immediately. Otherwise, it'll be saved to the DB when the
      # record is next saved.
      #
      #   person.avatar.attach(params[:avatar]) # ActionDispatch::Http::UploadedFile object
      #   person.avatar.attach(params[:signed_blob_id]) # Signed reference to blob from direct upload
      #   person.avatar.attach(io: File.open("/path/to/face.jpg"), filename: "face.jpg", content_type: "image/jpeg")
      #   person.avatar.attach(avatar_blob) # ActiveStorage::Blob object
      def attach(attachable, filename:)
        record.public_send("#{name}=", attachable, filename)
        blob.save! && upload(attachable)
        # :nocov:
        return if record.persisted? && !record.changed? && !record.save
        # :nocov:

        record.public_send(name.to_s)
      end

      def upload(attachable)
        case attachable
        when ActionDispatch::Http::UploadedFile, Pathname
          blob.upload_without_unfurling(attachable.open)
        when Rack::Test::UploadedFile
          blob.upload_without_unfurling(
            attachable.respond_to?(:open) ? attachable.open : attachable
          )
        when Hash
          blob.upload_without_unfurling(attachable.fetch(:io))
        when File
          blob.upload_without_unfurling(attachable)
        end
      rescue StandardError => e
        blob.destroy!
        raise e
      end

      # Returns the associated attachment record.
      #
      # You don't have to call this method to access the attachment's methods as
      # they are all available at the model level.
      def attachment
        if change.present?
          change.attachment
        else
          record.public_send("#{name}_storage_attachment")
        end
      end
    end
  end
end
