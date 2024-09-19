# frozen_string_literal: true

module StorageTables
  # The base class for all StorageTables controllers.
  class BaseController < ActionController::Base # rubocop:disable Rails/ApplicationController
    include StorageTables::SetCurrent

    protect_from_forgery with: :exception

    self.etag_with_template_digest = false
  end
end
        