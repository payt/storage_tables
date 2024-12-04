# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/securerandom"

module StorageTables
  class Service
    module SharedServiceTests
      extend ActiveSupport::Concern

      FIXTURE_DATA = ("a" * 64.kilobytes).freeze

      included do
        setup do
          @checksum = Checksum.from_string(FIXTURE_DATA)
          @service = self.class.const_get(:SERVICE)
          @service.upload @checksum, StringIO.new(FIXTURE_DATA)
        end

        test "uploading without integrity" do
          data = "Something else entirely!"
          checksum = Checksum.from_string("FIXTURE_DATA")

          assert_raises(StorageTables::IntegrityError) do
            @service.upload(checksum, StringIO.new(data))
          end

          assert_not @service.exist?(checksum)
        ensure
          @service.delete checksum
        end

        test "downloading" do
          assert_equal FIXTURE_DATA, @service.download(@checksum)
        end

        test "downloading a nonexistent file" do
          assert_raises(StorageTables::FileNotFoundError) do
            @service.download(Checksum.from_string(SecureRandom.base58(24)))
          end
        end

        test "downloading in chunks" do
          expected_chunks = ["a" * 5.megabytes, "b"]
          actual_chunks = []
          io = StringIO.new(expected_chunks.join)
          checksum = Checksum.from_io(expected_chunks.join)

          begin
            @service.upload checksum, io

            @service.download checksum do |chunk|
              actual_chunks << chunk
            end

            assert_equal expected_chunks, actual_chunks, "Downloaded chunks did not match uploaded data"
          ensure
            @service.delete checksum
          end
        end

        test "downloading a nonexistent file in chunks" do
          assert_raises(StorageTables::FileNotFoundError) do
            @service.download(SecureRandom.base58(24)) {} # rubocop:disable Lint/EmptyBlock
          end
        end

        test "downloading partially" do
          assert_equal "aaa", @service.download_chunk(@checksum, 19..21)
        end

        test "partially downloading a nonexistent file" do
          assert_raises(StorageTables::FileNotFoundError) do
            @service.download_chunk(SecureRandom.base58(24), 19..21)
          end
        end

        test "existing" do
          assert @service.exist?(@checksum)
          assert_not @service.exist?("#{@checksum}nonsense")
        end

        test "deleting" do
          @service.delete @checksum

          assert_not @service.exist?(@checksum)
        end

        test "deleting nonexistent key" do
          assert_nothing_raised do
            @service.delete SecureRandom.base58(24)
          end
        end
      end
    end
  end
end
