# frozen_string_literal: true

class CreateStorageTablesUserAttachmentsMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_tables_user_attachments, force: true do |t|
      t.string :name,         null: false
      t.string     :filename, null: false
      t.belongs_to :record,   null: false, foreign_key: { to_table: :users }
      t.string :checksum, null: false, foreign_key: false
      t.string :blob_key, null: false
      t.datetime :created_at, null: false

      t.index [:record_id, :checksum], unique: true
    end

    ActiveRecord::Base.connection.execute <<~SQL.squish
      ALTER TABLE storage_tables_user_attachments
      ADD CONSTRAINT fk_rails_1d0e0e0e7a
      FOREIGN KEY (checksum, blob_key)
      REFERENCES storage_tables_blobs (checksum, partition_key);
    SQL

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE TRIGGER storage_tables_user_attachments_created AFTER INSERT ON storage_tables_user_attachments FOR EACH ROW EXECUTE FUNCTION increment_attachment_counter()
    SQL
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE TRIGGER storage_tables_user_attachments_deleted AFTER INSERT ON storage_tables_user_attachments FOR EACH ROW EXECUTE FUNCTION decrement_attachment_counter()
    SQL
  end
end
