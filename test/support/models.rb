# frozen_string_literal: true

# frozen_literal_string: true

class Post < ApplicationRecord
  stored_one_attachment :image, class_name: "StorageTables::PostAttachment"
end

module StorageTables
  class PostAttachment < StorageTables::Attachment
    belongs_to :record, class_name: "Post", inverse_of: :image_storage_attachment
  end
end