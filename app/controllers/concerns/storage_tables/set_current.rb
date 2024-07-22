# frozen_string_literal: true

module StorageTables
  # Sets the <tt>StorageTables::Current.url_options</tt> attribute, which the disk service uses to generate URLs.
  # Include this concern in custom controllers that call StorageTables::Blob#url,
  # StorageTables::Variant#url, or StorageTables::Preview#url so the disk service can
  # generate URLs using the same host, protocol, and port as the current request.
  module SetCurrent
    extend ActiveSupport::Concern

    included do
      before_action do
        StorageTables::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
      end
    end
  end
end
