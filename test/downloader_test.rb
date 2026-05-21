# frozen_string_literal: true

require "test_helper"

class DownloaderStubService < StorageTables::Service
  CONTENT = "downloader test content"

  def download(_checksum)
    yield CONTENT
  end
end

module StorageTables
  class DownloaderTest < ActiveSupport::TestCase
    test "open yields file contents when checksum contains slash and plus characters" do
      checksum = "abc/def+ghi=="

      Downloader.new(DownloaderStubService.new).open(checksum, verify: false) do |file|
        assert_equal DownloaderStubService::CONTENT, file.read
      end
    end
  end
end
