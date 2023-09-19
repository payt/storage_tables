# frozen_string_literal: true

module StorageTables
  class Service
    class Registry
      def initialize(configurations)
        @configurations = configurations
      end

      def fetch(key)
        key = key.to_s.camelize
        @configurations.fetch(key) do
          raise(KeyError, "Missing service configuration for #{key}")
        end
      end
    end
  end
end
