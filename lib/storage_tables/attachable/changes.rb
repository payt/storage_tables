# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes # :nodoc:
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :CreateOne
      end
    end
  end
end
