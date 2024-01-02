# frozen_string_literal: true

module StorageTables
  # = Storage Tables \Attached \Many
  #
  # Decorated proxy object representing of multiple attachments to a model.
  module Attachable
    class Many < ActiveStorage::Attached::Many
    end
  end
end
