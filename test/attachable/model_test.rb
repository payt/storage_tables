# frozen_string_literal: true

require "test_helper"

module StorageTables
  class ModelTest < ActiveSupport::TestCase
    test "stored_one_attachment issues deprecation warning" do
      klass = Class.new(ActiveRecord::Base) do # rubocop:disable Rails/ApplicationRecord
        include StorageTables::Attachable::Model
        self.table_name = "users"
      end

      assert_deprecated("StorageTables", StorageTables.deprecator) do
        klass.stored_one_attachment :avatar, class_name: "StorageTables::UserAvatarAttachment"
      end
    end

    test "stored_many_attachments issues deprecation warning" do
      klass = Class.new(ActiveRecord::Base) do # rubocop:disable Rails/ApplicationRecord
        include StorageTables::Attachable::Model
        self.table_name = "users"
      end

      assert_deprecated("StorageTables", StorageTables.deprecator) do
        klass.stored_many_attachments :highlights, class_name: "StorageTables::UserPhotoAttachment"
      end
    end
  end
end
