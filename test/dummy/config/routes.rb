# frozen_string_literal: true

Rails.application.routes.draw do
  mount StorageTables::Engine => "/storage_tables"
end
