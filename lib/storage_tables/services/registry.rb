# frozen_string_literal: true

require "active_storage/service"
require "active_storage/service/registry"
require "storage_tables/services/configurator"

module StorageTables
  module Services
    class Registry < ActiveStorage::Service::Registry # :nodoc:
      private

      def configurator
        @configurator ||= StorageTables::Services::Configurator.new(configurations)
      end
    end
  end
end
