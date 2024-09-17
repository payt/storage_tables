# frozen_string_literal: true

module StorageTables
    class BaseController < ActionController::Base
        include StorageTables::SetCurrent

        # protect_from_forgery with: :exception
      
        self.etag_with_template_digest = false
    end
end