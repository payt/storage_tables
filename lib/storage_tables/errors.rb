# frozen_string_literal: true

module StorageTables
  # Generic base class for all Storage Tables exceptions.
  class Error < StandardError; end

  class ServiceError < Error; end

  class ActiveRecordError < Error; end

  # Raised when uploaded or downloaded data does not match a precomputed checksum.
  # Indicates that a network error or a software bug caused data corruption.
  class IntegrityError < Error; end
end
