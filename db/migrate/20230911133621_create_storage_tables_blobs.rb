# frozen_string_literal: true

class CreateStorageTablesBlobs < ActiveRecord::Migration[7.0]
  def up
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE TABLE storage_tables_blobs (
        partition_key character(1) NOT NULL,
        checksum character(85) NOT NULL,
        attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        attachments_count integer DEFAULT 0 NOT NULL,
        byte_size bigint NOT NULL,
        content_type character varying,
        metadata jsonb,
        PRIMARY KEY (checksum, partition_key)
        ) partition by LIST (partition_key);
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<~SQL.squish
      DROP TABLE storage_tables_blobs;
    SQL
  end
end
