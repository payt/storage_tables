# frozen_string_literal: true

require "storage_tables/service/configurator"

module StorageTables
  module Service
    class Registry < ActiveStorage::Service::Registry
      private

      def configurator
        @configurator ||= StorageTables::Service::Configurator.new(configurations)
      end
    end
  end
end
