# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/cassettes"
  config.hook_into :webmock

  config.default_cassette_options = { match_requests_on: [:method,
                                                          VCR.request_matchers.uri_without_param("X-Amz-Date",
                                                                                                 "X-Amz-Credential",
                                                                                                 "X-Amz-Signature")] }

  # To re-record, delete test/fixtures/cassettes/services/s3 and run the S3 service test with
  # valid AWS_* values in .env. Recording in place is not enough: VCR only drops a previously
  # recorded interaction when a new one matches it, so stale interactions survive.
  config.filter_sensitive_data("<AWS_ACCESS_ID>") { ENV.fetch("AWS_ACCESS_ID", nil) }
  config.filter_sensitive_data("<AWS_ACCESS_KEY>") { ENV.fetch("AWS_ACCESS_KEY", nil) }
end
