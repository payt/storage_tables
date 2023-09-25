# frozen_string_literal: true

module StorageTables
  # This class is used to hook into Rails
  class Engine < ::Rails::Engine
    isolate_namespace StorageTables
  end
end
