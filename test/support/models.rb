# frozen_string_literal: true

class User < ApplicationRecord
  stored_one_attachment :avatar, class_name: "StorageTables::UserAvatarAttachment"

  validates :name, presence: true
end

class Group < ApplicationRecord
  stored_one_attachment :image, class_name: "StorageTables::GroupAttachment"
end

module StorageTables
  class UserAvatarAttachment < StorageTables::Attachment
    belongs_to :record, class_name: "User", inverse_of: :avatar_storage_attachment
  end
end
