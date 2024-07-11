class PreventDeletionOfBlob < ActiveRecord::Migration[7.1]
  def up
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.storage_tables_prevent_delete() RETURNS trigger
        LANGUAGE plpgsql VOLATILE
        AS $$
          BEGIN
            IF OLD.attachments_count <> 0 THEN
                  RAISE EXCEPTION 'can not delete blobs with attachments'; 
            END IF;
            RETURN OLD;            
          END;
        $$;
    SQL

    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("").each_with_index do |char, index|
      ActiveRecord::Base.connection.execute <<~SQL.squish
        CREATE TRIGGER storage_tables_prevent_deletion BEFORE DELETE ON storage_tables_blobs_partition_#{index} FOR EACH ROW EXECUTE FUNCTION storage_tables_prevent_delete();
      SQL
    end
  end

  def down
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("").each_with_index do |char, index|
    ActiveRecord::Base.connection.execute <<~SQL.squish
        DROP TRIGGER storage_tables_prevent_deletion ON storage_tables_blobs_partition_#{index}
      SQL
    end

    ActiveRecord::Base.connection.execute <<~SQL.squish
      DROP FUNCTION storage_tables_prevent_delete(); 
    SQL
  end
end
