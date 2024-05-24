# frozen_string_literal: true

require "test_helper"
require "database/setup"

module StorageTables
  class ManyAttachedTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    setup do
      @user = User.create!(name: "Josh")
    end

    teardown do
      ActiveStorage::Blob.find_each(&:delete)
    end

    test "attaching existing blobs to an existing record" do
      @user.highlights.attach([create_blob(data: "funky.jpg"), "funky.jpg"],
                              [create_blob(data: "town.jpg"), "town.jpg"])

      assert_equal ["funky.jpg", "town.jpg"], @user.highlights.pluck(:filename).sort

      assert_not_empty @user.highlights_storage_attachments
      assert_equal 2, @user.highlights_storage_blobs.count
    end

    test "attaching existing blobs from signed IDs to an existing record" do
      @user.highlights.attach [create_blob(data: "funky.jpg").signed_id, "funky.jpg"],
                              [create_blob(data: "town.jpg").signed_id, "town.jpg"]

      assert_equal ["funky.jpg", "town.jpg"], @user.reload.highlights.pluck(:filename).sort
    end

    test "attaching new blobs from Hashes to an existing record" do
      @user.highlights.attach(
        { io: StringIO.new("STUFF"), filename: "funky.jpg", content_type: "image/jpeg" },
        { io: StringIO.new("THINGS"), filename: "town.jpg", content_type: "image/jpeg" }
      )

      assert_equal ["funky.jpg", "town.jpg"], @user.highlights.pluck(:filename).sort
    end

    test "attaching new blobs from uploaded files to an existing record" do
      @user.highlights.attach fixture_file_upload("racecar.jpg"), fixture_file_upload("video.mp4")

      assert_equal ["racecar.jpg", "video.mp4"], @user.highlights.pluck(:filename).sort
    end

    test "attaching existing blobs to an existing, changed record" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.highlights.attach [create_file_blob(filename: "image.gif"), "image.gif"],
                              [create_file_blob(filename: "report.pdf"), "report.pdf"]

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "report.pdf", @user.highlights.second.filename.to_s
      assert_not @user.highlights.first.persisted?
      assert_not @user.highlights.second.persisted?
      assert_predicate @user, :will_save_change_to_name?

      @user.save!

      assert_equal ["image.gif", "report.pdf"], @user.highlights.pluck(:filename).sort
    end

    test "attaching existing blobs from signed IDs to an existing, changed record" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.highlights.attach [create_file_blob(filename: "image.gif").signed_id, "image.gif"],
                              [create_file_blob(filename: "report.pdf").signed_id, "report.pdf"]

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "report.pdf", @user.highlights.second.filename.to_s
      assert_not @user.highlights.first.persisted?
      assert_not @user.highlights.second.persisted?
      assert_predicate @user, :will_save_change_to_name?

      @user.save!

      assert_equal ["image.gif", "report.pdf"], @user.highlights.pluck(:filename).sort
    end

    test "attaching new blobs from Hashes to an existing, changed record" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.highlights.attach(
        { io: StringIO.new("STUFF"), filename: "funky.jpg", content_type: "image/jpeg" },
        { io: StringIO.new("THINGS"), filename: "town.jpg", content_type: "image/jpeg" }
      )

      assert_equal "funky.jpg", @user.highlights.first.filename.to_s
      assert_equal "town.jpg", @user.highlights.second.filename.to_s
      assert_not @user.highlights.first.persisted?
      assert_not @user.highlights.second.persisted?
      assert_predicate @user, :will_save_change_to_name?

      @user.save!

      assert_equal ["funky.jpg", "town.jpg"], @user.highlights.pluck(:filename).sort
    end

    test "attaching new blobs from uploaded files to an existing, changed record" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.highlights.attach fixture_file_upload("racecar.jpg"), fixture_file_upload("video.mp4")

      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
      assert_equal "video.mp4", @user.highlights.second.filename.to_s
      assert_not @user.highlights.first.persisted?
      assert_not @user.highlights.second.persisted?
      assert_predicate @user, :will_save_change_to_name?

      @user.save!

      assert_equal ["racecar.jpg", "video.mp4"], @user.highlights.pluck(:filename).sort
    end

    test "attaching new blobs from uploaded files to an existing, changed record one at a time" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      assert_predicate @user, :changed?

      @user.highlights.attach fixture_file_upload("racecar.jpg")
      @user.highlights.attach fixture_file_upload("video.mp4")

      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
      assert_equal "video.mp4", @user.highlights.second.filename.to_s
      assert_not @user.highlights.first.persisted?
      assert_not @user.highlights.second.persisted?
      assert_predicate @user, :will_save_change_to_name?
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)

      @user.save!

      assert_equal "racecar.jpg", @user.reload.highlights.first.filename.to_s
      assert_equal "video.mp4", @user.highlights.second.filename.to_s
    end

    test "attaching new blobs within a transaction uploads all the files" do # rubocop:disable Minitest/MultipleAssertions
      @user.highlights.attach fixture_file_upload("image.gif")
      @user.highlights.attach fixture_file_upload("racecar.jpg")
      @user.highlights.attach fixture_file_upload("video.mp4")

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "racecar.jpg", @user.highlights.second.filename.to_s
      assert_equal "video.mp4", @user.highlights.third.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.third.full_checksum)
    end

    test "attaching many new blobs within a transaction uploads all the files" do # rubocop:disable Minitest/MultipleAssertions
      @user.highlights.attach fixture_file_upload("image.gif"), fixture_file_upload("racecar.jpg")
      @user.highlights.attach fixture_file_upload("video.mp4")

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "racecar.jpg", @user.highlights.second.filename.to_s
      assert_equal "video.mp4", @user.highlights.third.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.third.full_checksum)
    end

    test "attaching many new blobs within a transaction on a dirty record uploads all the files" do # rubocop:disable Minitest/MultipleAssertions
      @user.name = "Tina"

      @user.highlights.attach fixture_file_upload("image.gif")
      @user.highlights.attach fixture_file_upload("racecar.jpg")
      @user.highlights.attach fixture_file_upload("video.mp4")
      @user.save

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "racecar.jpg", @user.highlights.second.filename.to_s
      assert_equal "video.mp4", @user.highlights.third.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.third.full_checksum)
    end

    test "attaching many new blobs within a transaction on a new record uploads all the files" do
      user = User.create!(name: "John") do |u|
        u.highlights.attach(io: StringIO.new("STUFF"), filename: "funky.jpg", content_type: "image/jpeg")
        u.highlights.attach(io: StringIO.new("THINGS"), filename: "town.jpg", content_type: "image/jpeg")
      end

      assert_equal 2, user.highlights.count
      assert_equal "funky.jpg", user.highlights.first.filename.to_s
      assert_equal "town.jpg", user.highlights.second.filename.to_s
      assert StorageTables::Blob.service.exist?(user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(user.highlights.second.full_checksum)
    end

    test "attaching new blobs within a transaction create the exact amount of records" do # rubocop:disable Minitest/MultipleAssertions
      assert_difference -> { StorageTables::Blob.count }, +2 do
        @user.highlights.attach fixture_file_upload("racecar.jpg")
        @user.highlights.attach fixture_file_upload("video.mp4")
      end

      assert_equal 2, @user.highlights.count
      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
      assert_equal "video.mp4", @user.highlights.second.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)
    end

    test "attaching existing blobs to an existing record one at a time" do
      @user.highlights.attach [create_file_blob(filename: "image.gif"), "image.gif"]
      @user.highlights.attach [create_file_blob(filename: "report.pdf"), "report.pdf"]

      assert_equal ["image.gif", "report.pdf"], @user.highlights.pluck(:filename).sort

      @user.reload

      assert_equal ["image.gif", "report.pdf"], @user.highlights.pluck(:filename).sort
    end

    test "updating an existing record to attach existing blobs" do
      @user.update! highlights: [[create_file_blob(filename: "racecar.jpg"), "racecar.jpg"],
                                 [create_file_blob(filename: "video.mp4"), "video.mp4"]]

      assert_equal ["racecar.jpg", "video.mp4"], @user.highlights.pluck(:filename).sort
    end

    test "updating an existing record to attach existing blobs from signed IDs" do
      @user.update! highlights: [[create_file_blob(filename: "image.gif").signed_id, "image.gif"],
                                 [create_file_blob(filename: "report.pdf").signed_id, "report.pdf"]]

      assert_equal ["image.gif", "report.pdf"], @user.highlights.pluck(:filename).sort
    end

    test "successfully updating an existing record to attach new blobs from uploaded files" do
      @user.highlights = [fixture_file_upload("racecar.jpg"), fixture_file_upload("video.mp4")]

      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
      assert_not @user.highlights.second.persisted?
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)

      @user.save!

      assert_predicate @user.highlights.second, :persisted?
    end

    test "unsuccessfully updating an existing record to attach new blobs from uploaded files, will save the blobs" do
      assert_not @user.update(name: "",
                              highlights: [fixture_file_upload("racecar.jpg"),
                                           fixture_file_upload("video.mp4")])
      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
      assert_equal "video.mp4", @user.highlights.second.filename.to_s
      assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      assert StorageTables::Blob.service.exist?(@user.highlights.second.full_checksum)
    end

    test "replacing existing, dependent attachments on an existing record via assign and attach" do
      @user.highlights.attach [create_file_blob(filename: "racecar.jpg"), "racecar.jpg"],
                              [create_file_blob(filename: "image.gif"), "town.jpg"]

      @user.highlights = []

      assert_not @user.highlights.attached?

      perform_enqueued_jobs do
        @user.highlights.attach [create_file_blob(filename: "video.mp4"), "video.mp4"],
                                [create_file_blob(filename: "report.pdf"), "report.pdf"]
      end

      assert_equal "video.mp4", @user.highlights.first.filename.to_s
      assert_equal "report.pdf", @user.highlights.second.filename.to_s
      assert_equal 4, StorageTables::Blob.count
    end

    test "replacing existing, independent attachments on an existing record via assign and attach" do
      @user.highlights.attach [create_file_blob(filename: "video.mp4"), "video.mp4"]

      @user.highlights = []

      assert_not @user.highlights.attached?
    end

    test "replacing attachments with an empty list" do
      @user.highlights = []

      assert_empty @user.highlights
    end

    test "replacing attachments with a list containing empty items" do
      @user.highlights = [""]

      assert_empty @user.highlights
    end

    test "replacing attachments with a list containing a mixture of empty and present items" do
      @user.highlights = ["", fixture_file_upload("racecar.jpg")]

      assert_equal 1, @user.highlights.size
      assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
    end

    test "successfully updating an existing record to replace existing, independent attachments" do
      @user.highlights.attach [create_file_blob(filename: "video.mp4"), "video.mp4"],
                              [create_file_blob(filename: "racecar.jpg"), "racecar.jpg"]

      @user.update! highlights: [[create_file_blob(filename: "image.gif"), "image.gif"],
                                 [create_file_blob(filename: "report.pdf"), "report.pdf"]]

      assert_equal "image.gif", @user.highlights.first.filename.to_s
      assert_equal "report.pdf", @user.highlights.second.filename.to_s
    end

    test "updating an existing record to attach one new blob and one previously-attached blob" do
      [[create_file_blob(filename: "racecar.jpg"), "racecar.jpg"],
       [create_file_blob(filename: "image.gif"), "image.gif"]].tap do |blobs|
        @user.highlights.attach blobs.first

        perform_enqueued_jobs do
          assert_no_changes -> { @user.highlights_storage_attachments.first.id } do
            @user.update! highlights: blobs
          end
        end

        assert_equal "racecar.jpg", @user.highlights.first.filename.to_s
        assert_equal "image.gif", @user.highlights.second.filename.to_s
        assert StorageTables::Blob.service.exist?(@user.highlights.first.full_checksum)
      end
    end

    test "updating an existing record with attachments" do
      @user.highlights.attach [create_file_blob(filename: "racecar.jpg"), "racecar.jpg"],
                              [create_file_blob(filename: "image.gif"), "image.gif"]

      assert_difference -> { @user.reload.highlights.count }, -2 do
        @user.update! highlights: []
      end

      assert_difference -> { @user.reload.highlights.count }, 2 do
        @user.update! highlights: [[create_file_blob(filename: "video.mp4"), "video.mp4"],
                                   [create_file_blob(filename: "image.gif"), "wherever.jpg"]]
      end

      assert_difference -> { @user.reload.highlights.count }, -2 do
        @user.update! highlights: nil
      end
    end

    test "attaching existing blobs to a new record" do
      User.new(name: "Jason").tap do |user|
        user.highlights.attach [create_file_blob(filename: "racecar.jpg"), "racecar.jpg"],
                               [create_file_blob(filename: "image.gif"), "image.gif"]

        assert_predicate user, :new_record?
        assert_equal "racecar.jpg", user.highlights.first.filename.to_s

        user.save!

        assert_equal "racecar.jpg", user.highlights.first.filename.to_s
      end
    end

    test "attaching an existing blob from a signed ID to a new record" do
      User.new(name: "Jason").tap do |user|
        user.highlights.attach [create_file_blob(filename: "racecar.jpg").signed_id, "racecar.jpg"]

        assert_predicate user, :new_record?
        assert_equal "racecar.jpg", user.highlights.first.filename.to_s

        user.save!

        assert_equal "racecar.jpg", user.reload.highlights.first.filename.to_s
      end
    end

    test "attaching new blobs from Hashes to a new record" do # rubocop:disable Minitest/MultipleAssertions
      User.new(name: "Jason").tap do |user|
        user.highlights.attach(
          { io: StringIO.new("STUFF"), filename: "funky.jpg", content_type: "image/jpeg" },
          { io: StringIO.new("THINGS"), filename: "town.jpg", content_type: "image/jpeg" }
        )

        assert_predicate user, :new_record?
        assert_predicate user.highlights.first, :new_record?
        assert_predicate user.highlights.second, :new_record?
        assert_predicate user.highlights.first.blob, :persisted?
        assert_predicate user.highlights.second.blob, :persisted?
        assert_equal "funky.jpg", user.highlights.first.filename.to_s
        assert_equal "town.jpg", user.highlights.second.filename.to_s
        assert StorageTables::Blob.service.exist?(user.highlights.first.full_checksum)
        assert StorageTables::Blob.service.exist?(user.highlights.second.full_checksum)

        user.save!

        assert_predicate user.highlights.first, :persisted?
        assert_predicate user.highlights.second, :persisted?
        assert_predicate user.highlights.first.blob, :persisted?
        assert_predicate user.highlights.second.blob, :persisted?
        assert_equal "funky.jpg", user.reload.highlights.first.filename.to_s
        assert_equal "town.jpg", user.highlights.second.filename.to_s
      end
    end

    test "attaching new blobs from uploaded files to a new record" do # rubocop:disable Minitest/MultipleAssertions
      User.new(name: "Jason").tap do |user|
        user.highlights.attach fixture_file_upload("racecar.jpg"), fixture_file_upload("video.mp4")

        assert_predicate user, :new_record?
        assert_predicate user.highlights.first, :new_record?
        assert_predicate user.highlights.second, :new_record?
        assert_equal "racecar.jpg", user.highlights.first.filename.to_s
        assert_equal "video.mp4", user.highlights.second.filename.to_s
        assert StorageTables::Blob.service.exist?(user.highlights.first.full_checksum)
        assert StorageTables::Blob.service.exist?(user.highlights.second.full_checksum)

        user.save!

        assert_predicate user.highlights.first, :persisted?
        assert_predicate user.highlights.second, :persisted?
        assert_equal "racecar.jpg", user.reload.highlights.first.filename.to_s
        assert_equal "video.mp4", user.highlights.second.filename.to_s
      end
    end

    test "creating a record with existing blobs attached" do
      user = User.create!(name: "Jason",
                          highlights: [[create_file_blob(filename: "image.gif"), "image.gif"],
                                       [create_file_blob(filename: "report.pdf"), "report.pdf"]])

      assert_equal ["image.gif", "report.pdf"], user.highlights.pluck(:filename).sort
    end

    test "creating a record with an existing blob from signed IDs attached" do
      user = User.create!(name: "Jason", highlights: [
                            [create_file_blob(filename: "image.gif").signed_id,
                             "image.gif"], [create_file_blob(filename: "report.pdf").signed_id, "report.pdf"]
                          ])

      assert_equal ["image.gif", "report.pdf"], user.highlights.pluck(:filename).sort
    end

    test "creating a record with new blobs from uploaded files attached" do # rubocop:disable Minitest/MultipleAssertions
      User.new(name: "Jason",
               highlights: [[fixture_file_upload("racecar.jpg")],
                            [fixture_file_upload("video.mp4"), "video.mp4"]]).tap do |user|
        assert_predicate user, :new_record?
        assert_predicate user.highlights.first, :new_record?
        assert_predicate user.highlights.second, :new_record?
        assert_predicate user.highlights.first.blob, :persisted?
        assert_predicate user.highlights.second.blob, :persisted?
        assert_equal "racecar.jpg", user.highlights.first.filename.to_s
        assert_equal "video.mp4", user.highlights.second.filename.to_s

        user.save!

        assert_equal "racecar.jpg", user.highlights.first.filename.to_s
        assert_equal "video.mp4", user.highlights.second.filename.to_s
      end
    end

    test "creating a record with an unexpected object attached" do
      error = assert_raises(ArgumentError) { User.create!(name: "Jason", highlights: :foo) }

      assert_equal "Could not find or build blob: expected attachable, got :foo", error.message
    end

    test "clearing change on reload" do
      @user.highlights = [create_file_blob(filename: "image.gif"), create_file_blob(filename: "racecar.jpg")]

      assert_predicate @user.highlights, :attached?

      @user.reload

      assert_not @user.highlights.attached?
    end

    test "attaching blobs to a persisted, unchanged, and valid record, returns the attachments" do
      @user.highlights.attach [create_file_blob(filename: "racecar.jpg"), "racecar.jpg"]
      return_value = @user.highlights.attach [create_file_blob(filename: "image.gif"), "image.gif"],
                                             [create_file_blob(filename: "report.pdf"), "report.pdf"]

      assert_equal @user.highlights, return_value
    end

    test "attaching blobs to a persisted, unchanged, and invalid record, returns nil" do
      @user.update_attribute(:name, nil) # rubocop:disable Rails/SkipsModelValidations

      assert_not @user.valid?

      @user.highlights.attach create_file_blob(filename: "racecar.jpg")
      return_value = @user.highlights.attach create_file_blob(filename: "image.gif"),
                                             create_file_blob(filename: "report.pdf")

      assert_nil return_value
    end

    test "attaching blobs to a changed record, returns the attachments" do
      @user.name = "Tina"
      @user.highlights.attach create_file_blob(filename: "racecar.jpg")
      return_value = @user.highlights.attach create_file_blob(filename: "image.gif"),
                                             create_file_blob(filename: "report.pdf")

      assert_equal @user.highlights, return_value
    end

    test "attaching blobs to a non persisted record, returns the attachments" do
      user = User.new(name: "John")
      user.highlights.attach create_file_blob(filename: "racecar.jpg")
      return_value = user.highlights.attach create_file_blob(filename: "image.gif"),
                                            create_file_blob(filename: "report.pdf")

      assert_equal user.highlights, return_value
    end

    # test "creating variation by variation name" do
    #   assert_no_enqueued_jobs only: ActiveStorage::TransformJob do
    #     @user.highlights_with_variants.attach fixture_file_upload("racecar.jpg")
    #   end
    #   variant = @user.highlights_with_variants.first.variant(:thumb).processed

    #   image = read_image(variant)

    #   assert_equal "JPEG", image.type
    #   assert_equal 100, image.width
    #   assert_equal 67, image.height
    # end

    # test "raises error when unknown variant name is used to generate variant" do
    #   @user.highlights_with_variants.attach fixture_file_upload("racecar.jpg")

    #   error = assert_raises ArgumentError do
    #     @user.highlights_with_variants.first.variant(:unknown).processed
    #   end

    #   assert_match(/Cannot find variant :unknown for User#highlights_with_variants/, error.message)
    # end

    # test "creating preview by variation name" do
    #   @user.highlights_with_variants.attach fixture_file_upload("report.pdf")
    #   preview = @user.highlights_with_variants.first.preview(:thumb).processed

    #   image = read_image(preview.send(:variant))

    #   assert_equal "PNG", image.type
    #   assert_equal 77, image.width
    #   assert_equal 100, image.height
    # end

    # test "raises error when unknown variant name is used to generate preview" do
    #   @user.highlights_with_variants.attach fixture_file_upload("report.pdf")

    #   error = assert_raises ArgumentError do
    #     @user.highlights_with_variants.first.preview(:unknown).processed
    #   end

    #   assert_match(/Cannot find variant :unknown for User#highlights_with_variants/, error.message)
    # end

    # test "creating representation by variation name" do
    #   @user.highlights_with_variants.attach fixture_file_upload("racecar.jpg")
    #   variant = @user.highlights_with_variants.first.representation(:thumb).processed

    #   image = read_image(variant)

    #   assert_equal "JPEG", image.type
    #   assert_equal 100, image.width
    #   assert_equal 67, image.height
    # end

    # test "raises error when unknown variant name is used to generate representation" do
    #   @user.highlights_with_variants.attach fixture_file_upload("racecar.jpg")

    #   error = assert_raises ArgumentError do
    #     @user.highlights_with_variants.first.representation(:unknown).processed
    #   end

    #   assert_match(/Cannot find variant :unknown for User#highlights_with_variants/, error.message)
    # end

    # test "transforms variants later" do
    #   blob = create_file_blob(filename: "racecar.jpg")

    #   assert_enqueued_with job: ActiveStorage::TransformJob, args: [blob, { resize_to_limit: [1, 1] }] do
    #     @user.highlights_with_preprocessed.attach blob
    #   end
    # end

    # test "transforms variants later conditionally via proc" do
    #   assert_no_enqueued_jobs only: ActiveStorage::TransformJob do
    #     @user.highlights_with_conditional_preprocessed.attach create_file_blob(filename: "racecar.jpg")
    #   end

    #   blob = create_file_blob(filename: "racecar.jpg")
    #   @user.update(name: "transform via proc")

    #   assert_enqueued_with job: ActiveStorage::TransformJob, args: [blob, { resize_to_limit: [2, 2] }] do
    #     @user.highlights_with_conditional_preprocessed.attach blob
    #   end
    # end

    # test "transforms variants later conditionally via method" do
    #   assert_no_enqueued_jobs only: ActiveStorage::TransformJob do
    #     @user.highlights_with_conditional_preprocessed.attach create_file_blob(filename: "racecar.jpg")
    #   end

    #   blob = create_file_blob(filename: "racecar.jpg")
    #   @user.update(name: "transform via method")

    #   assert_enqueued_with job: ActiveStorage::TransformJob, args: [blob, { resize_to_limit: [3, 3] }] do
    #     @user.highlights_with_conditional_preprocessed.attach blob
    #   end
    # end

    # test "avoids enqueuing transform later job when blob is not representable" do
    #   unrepresentable_blob = create_file_blob(filename:  "hello.txt")

    #   assert_no_enqueued_jobs only: ActiveStorage::TransformJob do
    #     @user.highlights_with_preprocessed.attach unrepresentable_blob
    #   end
    # end
  end
end
