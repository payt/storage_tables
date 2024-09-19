# frozen_string_literal: true

module StorageTables
  # Base controller for all controllers in the storage_tables engine.
  class BaseController < ApplicationController
    include StorageTables::SetCurrent

    protect_from_forgery with: :exception

    self.etag_with_template_digest = false
  end
end
