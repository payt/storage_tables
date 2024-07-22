# frozen_string_literal: true

module StorageTables
  class Current < ActiveSupport::CurrentAttributes # :nodoc:
    attribute :url_options
  end
end
