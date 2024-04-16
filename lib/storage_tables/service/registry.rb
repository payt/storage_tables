# frozen_string_literal: true

require "active_storage/service/registry"
require "storage_tables/service/configurator"

module StorageTables
  module Service
    class Registry < ActiveStorage::Service::Registry # :nodoc:
      private

      def configurator
        @configurator ||= StorageTables::Service::Configurator.new(configurations)
      end
    end
  end
end
