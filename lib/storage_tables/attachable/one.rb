# frozen_string_literal: true

module StorageTables
  module Attachable
    # Representation of a single attachment to a model.
    class One < Attached
      include Changes::Helper

      delegate :blob, to: :attachment

      # Returns +true+ if an attachment is not attached.
      #
      #   class User < ApplicationRecord
      #     has_one_attached :avatar
      #   end
      #
      #   User.new.avatar.blank? # => true
      def blank?
        !attached?
      end

      # Returns +true+ if an attachment has been made.
      #
      #   class User < ApplicationRecord
      #     has_one_attached :avatar
      #   end
      #
      #   User.new.avatar.attached? # => false
      def attached?
        attachment.present?
      end

      # Attaches an +attachable+ to the record.
      #
      # If the record is persisted and unchanged, the attachment is saved to
      # the database immediately. Otherwise, it'll be saved to the DB when the
      # record is next saved.
      #
      #   person.avatar.attach(params[:avatar]) # ActionDispatch::Http::UploadedFile object
      #   person.avatar.attach(params[:signed_blob_id], filename: "Blob.file") # Signed reference to blob
      #   person.avatar.attach(io: File.open("/path/to/face.jpg"), filename: "face.jpg", content_type: "image/jpeg")
      #   person.avatar.attach(avatar_blob, filename: "Blob.file") # StorageTables::Blob or ActiveStorage::Blob object
      #
      # If the filename cannot be determined from the attachable, pass the filename as option: +filename+.
      def attach(attachable, filename: nil)
        filename ||= extract_filename(attachable)

        raise ArgumentError, "Could not determine filename from #{attachable.inspect}" unless filename

        record.public_send(:"#{name}=", attachable, filename)
        blob.save! && upload(attachable, blob)
        # :nocov:
        return if record.persisted? && !record.changed? && !record.save
        # :nocov:

        record.public_send(name.to_s)
      end

      # Returns the associated attachment record.
      #
      # You don't have to call this method to access the attachment's methods as
      # they are all available at the model level.
      def attachment
        if change.present?
          change.attachment
        else
          record.public_send(:"#{name}_storage_attachment")
        end
      end
    end
  end
end
