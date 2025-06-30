# frozen_string_literal: true

Rails.application.routes.draw do
  scope StorageTables.routes_prefix do
    put "/disk/:encoded_token" => "storage_tables/disk#update", as: :update_storage_tables_disk_service
    get "/disk/:encoded_checksum" => "storage_tables/disk#show", as: :show_storage_tables_disk_service
  end
end
