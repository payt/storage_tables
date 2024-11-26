# frozen_string_literal: true

require "test_helper"

module StorageTables
  class ReflectionTest < ActiveSupport::TestCase
    test "reflecting on a singular attachment" do
      reflection = User.reflect_on_attachment(:avatar)

      assert_equal User, reflection.active_record
      assert_equal :avatar, reflection.name
      assert_equal :stored_one_attachment, reflection.macro
      # assert_equal :purge_later, reflection.options[:dependent]

      reflection = User.reflect_on_attachment(:avatar)

      assert_equal "StorageTables::UserAvatarAttachment", reflection.options[:class_name]

      # reflection = User.reflect_on_attachment(:avatar_with_variants)

      # assert_instance_of Hash, reflection.named_variants
    end

    test "reflection on a singular attachment with the same name as an attachment on another model" do
      reflection = Group.reflect_on_attachment(:image)

      assert_equal Group, reflection.active_record
    end

    test "reflecting on all attachments" do
      reflections = User.reflect_on_all_attachments.sort_by(&:name)

      assert_equal [User], reflections.collect(&:active_record).uniq
      assert_equal [:avatar, :highlights],
                   reflections.collect(&:name)
      assert_equal [:stored_one_attachment, :stored_many_attachments],
                   reflections.collect(&:macro)
    end
  end
end
