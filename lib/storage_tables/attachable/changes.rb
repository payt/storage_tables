# frozen_string_literal: true

module StorageTables
  module Attachable
    module Changes # :nodoc:
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Helper
        autoload :ManyHelper
        autoload :CreateOne
        autoload :CreateMany
        autoload :CreateOneOfMany
        autoload :DeleteOne
        autoload :DeleteMany
      end
    end
  end
end
