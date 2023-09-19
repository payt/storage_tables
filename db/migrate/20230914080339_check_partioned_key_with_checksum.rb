# frozen_string_literal: true

class CheckPartionedKeyWithChecksum < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    ActiveRecord::Base.connection.execute <<~SQL.squish
      ALTER TABLE storage_tables_blobs
        ADD CONSTRAINT partition_key_is_checksum_first_letter CHECK (partition_key = (left(checksum, 1))) NOT VALID;
    SQL

    validate_constraint(:storage_tables_blobs, :partition_key_is_checksum_first_letter)
  end

  def down
    ActiveRecord::Base.connection.execute("ALTER TABLE storage_tables_blobs DROP CONSTRAINT partition_key_is_checksum_first_letter")
  end
end
