# frozen_string_literal: true

require "service/shared_service_tests"

module StorageTables
  class Service
    class MirrorServiceTest < ActiveSupport::TestCase
      mirror_config = (1..3).to_h do |i|
        ["mirror_#{i}",
         { service: "Disk",
           root: Dir.mktmpdir("active_storage_tests_mirror_#{i}") }]
      end

      config = mirror_config.merge \
        mirror: { service: "Mirror", primary: "primary", mirrors: mirror_config.keys },
        primary: { service: "Disk", root: Dir.mktmpdir("active_storage_tests_primary") }

      SERVICE = StorageTables::Service.configure :mirror, config

      include StorageTables::Service::SharedServiceTests
      include ActiveJob::TestHelper

      test "name" do
        assert_equal :mirror, @service.name
      end

      test "uploading to all services" do
        old_service = StorageTables::Blob.service
        StorageTables::Blob.service = @service

        data     = "Something else entirely!"
        io       = StringIO.new(data)
        checksum = generate_checksum(data)

        assert_performed_jobs 1, only: StorageTables::MirrorJob do
          @service.upload checksum, io.tap(&:read)
        end

        assert_equal data, @service.primary.download(checksum)
        @service.mirrors.each do |mirror|
          assert_equal data, mirror.download(checksum)
        end
      ensure
        @service.delete checksum
        StorageTables::Blob.service = old_service
      end

      test "downloading from primary service" do
        data     = "Something else entirely!"
        checksum = generate_checksum(data)

        @service.primary.upload(checksum, StringIO.new(data))

        assert_equal data, @service.download(checksum)
      end

      test "deleting from all services" do
        @service.delete @checksum

        assert_not SERVICE.primary.exist?(@checksum)
        SERVICE.mirrors.each do |mirror|
          assert_not mirror.exist?(@checksum)
        end
      end

      test "mirroring a file from the primary service to secondary services where it doesn't exist" do
        data     = "Something else entirely!"
        checksum = generate_checksum(data)

        @service.primary.upload(checksum, StringIO.new(data))

        @service.mirror(checksum)

        assert_equal data, @service.mirrors.first.download(checksum)
        assert_equal data, @service.mirrors.second.download(checksum)
        assert_equal data, @service.mirrors.third.download(checksum)
      end

      test "mirroring a file from the primary service to secondary services where it already exists" do
        data     = "Something else entirely!"
        checksum = generate_checksum(data)

        @service.primary.upload(checksum, StringIO.new(data))
        @service.mirrors.each { |mirror| mirror.upload checksum, StringIO.new(data) }

        @service.mirror(checksum)

        assert_equal data, @service.mirrors.first.download(checksum)
        assert_equal data, @service.mirrors.second.download(checksum)
        assert_equal data, @service.mirrors.third.download(checksum)
      end

      test "when file doesn't exist on primary when mirroring" do
        checksum = generate_checksum(name)

        assert_raises StorageTables::FileNotFoundError do
          @service.mirror(checksum)
        end
      end

      test "path for file in primary service" do
        assert_equal @service.primary.path_for(@checksum), @service.path_for(@checksum)
      end
    end
  end
end
