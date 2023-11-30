# frozen_string_literal: true

class CreateStorageTablesUserAttachmentsMigration < ActiveRecord::Migration[7.1]
  def up
    create_table :storage_tables_user_avatar_attachments, primary_key: [:record_id, :blob_key, :checksum],
                                                          force: :cascade do |t|
      t.string :blob_key, null: false, limit: 1
      t.string :checksum, limit: 85, null: false
      t.references :record, null: false, foreign_key: { to_table: :users }
      t.datetime :created_at, null: false
      t.string :filename, null: false
    end

    ActiveRecord::Base.connection.execute <<~SQL.squish
      ALTER TABLE storage_tables_user_avatar_attachments
      ADD CONSTRAINT fk_rails_1d0e0e0e7a
      FOREIGN KEY (checksum, blob_key)
      REFERENCES storage_tables_blobs (checksum, partition_key);
    SQL

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE TRIGGER storage_tables_user_attachments_created AFTER INSERT ON storage_tables_user_avatar_attachments FOR EACH ROW EXECUTE FUNCTION increment_attachment_counter()
    SQL
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE TRIGGER storage_tables_user_attachments_deleted AFTER INSERT ON storage_tables_user_avatar_attachments FOR EACH ROW EXECUTE FUNCTION decrement_attachment_counter()
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL.squish
      DROP TABLE storage_tables_user_avatar_attachments;
    SQL
  end
end
