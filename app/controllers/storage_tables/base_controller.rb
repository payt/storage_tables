# frozen_string_literal: true

# The base class for all Active Storage controllers.
module StorageTables
  class BaseController < ActionController::Base # rubocop:disable Rails/ApplicationController
    include StorageTables::SetCurrent

    protect_from_forgery with: :exception

    self.etag_with_template_digest = false
  end
end
