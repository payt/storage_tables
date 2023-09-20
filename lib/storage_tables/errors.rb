# frozen_string_literal: true

module StorageTables
  # Generic base class for all Storage Tables exceptions.
  class Error < StandardError; end

  class ServiceError < Error; end
end
