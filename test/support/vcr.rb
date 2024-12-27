# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/cassettes"
  config.hook_into :webmock

  config.default_cassette_options = { match_requests_on: [:method,
                                                          VCR.request_matchers.uri_without_param("X-Amz-Date",
                                                                                                 "X-Amz-Credential",
                                                                                                 "X-Amz-Signature")] }
end
