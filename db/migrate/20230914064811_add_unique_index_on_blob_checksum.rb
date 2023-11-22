# frozen_string_literal: true

class AddUniqueIndexOnBlobChecksum < ActiveRecord::Migration[7.0]
  def change
    add_index :storage_tables_blobs, :checksum, where: "attachments_count = 0"

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.increment_attachment_counter() RETURNS trigger
      LANGUAGE plpgsql VOLATILE
      AS $$
      BEGIN
        UPDATE storage_tables_blobs
        SET attachments_count = attachments_count + 1,
            attachments_count_modified = CURRENT_TIMESTAMP
        WHERE checksum = NEW.checksum;
        RETURN NEW;
      END;
      $$;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.decrement_attachment_counter() RETURNS trigger
      LANGUAGE plpgsql VOLATILE
      AS $$
      BEGIN
        UPDATE storage_tables_blobs
        SET attachments_count = attachments_count - 1,
            attachments_count_modified = CURRENT_TIMESTAMP
        WHERE checksum = NEW.checksum;
        RETURN NEW;
      END;
      $$;
    SQL
  end
end
