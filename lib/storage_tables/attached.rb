# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module StorageTables
  #
  # Abstract base class for the concrete StorageTables::Attached::One and StorageTables::Attached::Many
  # classes that both provide proxy access to the blob association for a record.
  class Attached
    attr_reader :name, :record

    def initialize(name, record)
      @name = name
      @record = record
    end

    private

    def change
      record.attachment_changes[name]
    end
  end
end

require "storage_tables/attached/model"
require "storage_tables/attached/changes"
