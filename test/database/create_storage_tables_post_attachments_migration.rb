# frozen_string_literal: true

class CreateStorageTablesPostAttachmentsMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_tables_post_attachments do |t|
      t.string :name,         null: false
      t.string     :filename, null: false
      t.references :record,   null: false, foreign_key: { to_table: :posts }
      t.references :blob,     null: false
      t.string     :blob_key, null: false
      t.datetime :created_at, null: false

      t.foreign_key :storage_tables_blobs, column: [:checksum, :blob_key], primary_key: [:checksum, :partition_key]
      t.index [:record, :blob], unique: true
    end
  end
end
