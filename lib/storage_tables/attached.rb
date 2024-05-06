# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module StorageTables
  #
  # Abstract base class for the concrete StorageTables::Attached::One and StorageTables::Attached::Many
  # classes that both provide proxy access to the blob association for a record.
  class Attached < ActiveStorage::Attached
  end
end

require "storage_tables/attachable/changes"
require "storage_tables/attachable/model"
require "storage_tables/attachable/one"
