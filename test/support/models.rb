# frozen_string_literal: true

class User < ApplicationRecord
  has_one_stored :avatar, class_name: "StorageTables::UserAvatarAttachment"
  has_many_stored :highlights, class_name: "StorageTables::UserPhotoAttachment"

  validates :name, presence: true
end

class Group < ApplicationRecord
  has_one_stored :image, class_name: "StorageTables::GroupAttachment"
end

module StorageTables
  class UserAvatarAttachment < StorageTables::Attachment
    belongs_to :record, class_name: "User", inverse_of: :avatar_storage_attachment
  end

  class UserPhotoAttachment < StorageTables::Attachment
    self.primary_key = [:record_id, :blob_key, :checksum]

    belongs_to :record, class_name: "User", inverse_of: :highlights_storage_attachments
  end
end
