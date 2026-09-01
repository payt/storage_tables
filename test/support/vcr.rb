# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/cassettes"
  config.hook_into :webmock

  # Cassettes are replayed by default. Set VCR_RECORD_MODE=all to re-record them against the
  # real AWS_BUCKET, which needs valid AWS_ACCESS_ID and AWS_ACCESS_KEY values.
  config.default_cassette_options = {
    record: ENV.fetch("VCR_RECORD_MODE", "once").to_sym,
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param("X-Amz-Date", "X-Amz-Credential", "X-Amz-Signature")
    ]
  }

  config.filter_sensitive_data("<AWS_ACCESS_ID>") { ENV.fetch("AWS_ACCESS_ID", nil) }
  config.filter_sensitive_data("<AWS_ACCESS_KEY>") { ENV.fetch("AWS_ACCESS_KEY", nil) }
end
