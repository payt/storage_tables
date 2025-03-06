# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module StorageTables
  class Service
    # = Storage Tables Mirror \Service
    #
    # Wraps a set of mirror services and provides a single StorageTables::Service object that will all
    # have the files uploaded to them. A +primary+ service is designated to answer calls to:
    # * +download+
    # * +exists?+
    # * +url+
    # * +url_for_direct_upload+
    # * +headers_for_direct_upload+
    class MirrorService < Service
      attr_reader :primary, :mirrors

      delegate :download, :download_chunk, :exist?, :url,
               :url_for_direct_upload, :headers_for_direct_upload, :path_for, :compose, to: :primary

      # Stitch together from named services.
      def self.build(primary:, mirrors:, name:, configurator:, **) # :nodoc:
        new(
          primary: configurator.build(primary),
          mirrors: mirrors.collect { |mirror_name| configurator.build mirror_name }
        ).tap do |service_instance|
          service_instance.name = name
        end
      end

      def initialize(primary:, mirrors:) # rubocop:disable Lint/MissingSuper
        @primary = primary
        @mirrors = mirrors
        @executor = Concurrent::ThreadPoolExecutor.new(
          min_threads: 1,
          max_threads: mirrors.size,
          max_queue: 0,
          fallback_policy: :caller_runs,
          idle_time: 60
        )
      end

      # Upload the +io+ to the +checksum+ specified to all services. The upload to the primary service is done
      # synchronously whereas the upload to the mirrors is done asynchronously. If a +checksum+ is provided, all
      # services will ensure a match when the upload has completed or raise an StorageTables::IntegrityError.
      def upload(checksum, io, **)
        io.rewind
        primary.upload(checksum, io, **)
        mirror_later checksum
      end

      # Delete the file at the +checksum+ on all services.
      def delete(checksum)
        perform_across_services :delete, checksum
      end

      def mirror_later(checksum)
        StorageTables::MirrorJob.perform_later checksum
      end

      # Copy the file at the +checksum+ from the primary service to each of the mirrors where it doesn't already exist.
      def mirror(checksum)
        instrument(:mirror, checksum:) do
          if (mirrors_in_need_of_mirroring = mirrors.reject { |service| service.exist?(checksum) }).any?
            primary.open(checksum) do |io|
              mirrors_in_need_of_mirroring.each do |service|
                io.rewind
                service.upload checksum, io
              end
            end
          end
        end
      end

      private

      def each_service(&)
        [primary, *mirrors].each(&)
      end

      def perform_across_services(method, *args)
        tasks = each_service.collect do |service|
          Concurrent::Promise.execute(executor: @executor) do
            service.public_send method, *args
          end
        end
        tasks.each(&:value!)
      end
    end
  end
end
