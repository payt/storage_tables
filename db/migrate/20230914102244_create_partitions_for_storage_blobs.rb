class CreatePartitionsForStorageBlobs < ActiveRecord::Migration[7.0]
  def up
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("").each_with_index do |char, index|
      ActiveRecord::Base.connection.execute <<~SQL.squish
        CREATE TABLE storage_tables_blobs_partition_#{index} PARTITION OF storage_tables_blobs
        FOR VALUES IN ('#{char}');
      SQL
    end
  end
end
