# frozen_string_literal: true

# require "service/shared_service_tests"

module StorageTables
  module Services
    class ConfiguratorTest < ActiveSupport::TestCase
      test "builds correct service instance based on service name" do
        service = StorageTables::Services::Configurator.build(:foo, foo: { service: "Disk", root: "path" })

        assert_instance_of StorageTables::Services::DiskService, service
        assert_equal "path", service.root
      end

      test "builds correct service instance based on lowercase service name" do
        service = StorageTables::Services::Configurator.build(:foo, foo: { service: "disk", root: "path" })

        assert_instance_of StorageTables::Services::DiskService, service
        assert_equal "path", service.root
      end

      test "raises error when not using disk service" do
        assert_raise RuntimeError do
          StorageTables::Services::Configurator.build(:bigfoot, { bigfoot: { service: "aws", root: "path" } })
        end
      end

      test "raises error when passing non-existent service name" do
        assert_raise RuntimeError do
          StorageTables::Services::Configurator.build(:bigfoot, {})
        end
      end
    end
  end
end
