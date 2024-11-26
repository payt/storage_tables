# frozen_string_literal: true

Rails.application.routes.draw do
  scope StorageTables.routes_prefix do
    put "/disk/:encoded_token" => "storage_tables/disk#update", as: :update_storage_tables_disk_service
  end
end
