SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: decrement_attachment_counter(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.decrement_attachment_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN UPDATE storage_tables_blobs SET attachments_count = attachments_count - 1, attachments_count_modified = CURRENT_TIMESTAMP WHERE checksum = NEW.checksum; RETURN NEW; END; $$;


--
-- Name: increment_attachment_counter(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.increment_attachment_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN UPDATE storage_tables_blobs SET attachments_count = attachments_count + 1, attachments_count_modified = CURRENT_TIMESTAMP WHERE checksum = NEW.checksum; RETURN NEW; END; $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: storage_tables_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
)
PARTITION BY LIST (partition_key);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_storage_tables_blobs_on_attachments_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_storage_tables_blobs_on_attachments_count ON ONLY public.storage_tables_blobs USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: index_storage_tables_blobs_on_partition_key_and_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_storage_tables_blobs_on_partition_key_and_checksum ON ONLY public.storage_tables_blobs USING btree (partition_key, checksum);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230911133621'),
('20230914064811'),
('20230914080339');


