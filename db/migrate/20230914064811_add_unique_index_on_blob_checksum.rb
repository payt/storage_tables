# frozen_string_literal: true

class AddUniqueIndexOnBlobChecksum < ActiveRecord::Migration[7.0]
  def up
    add_index :storage_tables_blobs, :checksum, where: "attachments_count = 0"
    
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.partition_keys() RETURNS text[]
      LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE
          AS $$
      DECLARE
        list TEXT[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,+,/}';
      BEGIN
      RETURN list;
      END;
      $$;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.increment_attachment_counter() RETURNS trigger
      LANGUAGE plpgsql VOLATILE
      AS $$
      BEGIN
        UPDATE storage_tables_blobs
        SET attachments_count = attachments_count + 1,
            attachments_count_modified = CURRENT_TIMESTAMP
        WHERE partition_key = NEW.blob_key AND checksum = NEW.checksum;
        RETURN NULL;
        END;
        $$;
        SQL
        
    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.decrement_attachment_counter() RETURNS trigger
        LANGUAGE plpgsql VOLATILE
        AS $$
        DECLARE
        index integer;
        BEGIN
        UPDATE storage_tables_blobs
        SET attachments_count = attachments_count - 1,
            attachments_count_modified = CURRENT_TIMESTAMP
        WHERE partition_key = NEW.blob_key AND checksum = NEW.checksum;
        RETURN NULL;
      END;
      $$;
    SQL

    ActiveRecord::Base.connection.execute <<~SQL.squish
      CREATE OR REPLACE FUNCTION public.immutable_blob_key_and_checksum() RETURNS trigger
        LANGUAGE plpgsql VOLATILE
        AS $$
        
          BEGIN
          IF NEW.checksum <> OLD.checksum THEN
                RAISE EXCEPTION 'updating checksum not allowed';
          END IF;
          IF NEW.partition_key <> OLD.partition_key THEN
                RAISE EXCEPTION 'updating partition_key not allowed';
          END IF;
          RETURN NEW;
            
          END;
        $$;
    SQL
  end
end
