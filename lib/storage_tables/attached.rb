# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module StorageTables
  #
  # Abstract base class for the concrete StorageTables::Attached::One and StorageTables::Attached::Many
  # classes that both provide proxy access to the blob association for a record.
  class Attached
    attr_reader :name, :record, :default_disposition

    def initialize(name, record, default_disposition: nil)
      @name = name
      @record = record
      @default_disposition = default_disposition
    end

    private

    def change
      record.attachment_changes[name]
    end
  end
end

require "storage_tables/attachable/changes"
require "storage_tables/attachable/model"
require "storage_tables/attachable/one"
require "storage_tables/attachable/many"
