# frozen_literal_string: true

class Post < ApplicationRecord
  stored_one_attachment :image, class_name: "StorageTables::PostAttachment"
end
