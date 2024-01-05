# frozen_string_literal: true

class User < ApplicationRecord
  stored_one_attachment :avatar, class_name: "StorageTables::UserAvatarAttachment"
  stored_many_attachments :highlights, class_name: "StorageTables::UserPhotoAttachment"

  validates :name, presence: true
end

class Group < ApplicationRecord
  stored_one_attachment :image, class_name: "StorageTables::GroupAttachment"
end

module StorageTables
  class UserAvatarAttachment < StorageTables::Attachment
    belongs_to :record, class_name: "User", inverse_of: :avatar_storage_attachment
  end

  class UserPhotoAttachment < StorageTables::Attachment
    belongs_to :record, class_name: "User", inverse_of: :highlights_storage_attachments
  end
end
