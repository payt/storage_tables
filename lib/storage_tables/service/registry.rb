# frozen_string_literal: true

module StorageTables
  module Service
    class Registry < ActiveStorage::Service::Registry
      def configurator
        @configurator ||= StorageTables::Service::Configurator.new(configurations)
      end
    end
  end
end
