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
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
)
PARTITION BY LIST (partition_key);


--
-- Name: storage_tables_blobs_partition_0; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_0 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_0 FOR VALUES IN ('A');


--
-- Name: storage_tables_blobs_partition_1; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_1 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_1 FOR VALUES IN ('B');


--
-- Name: storage_tables_blobs_partition_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_10 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_10 FOR VALUES IN ('K');


--
-- Name: storage_tables_blobs_partition_11; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_11 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_11 FOR VALUES IN ('L');


--
-- Name: storage_tables_blobs_partition_12; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_12 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_12 FOR VALUES IN ('M');


--
-- Name: storage_tables_blobs_partition_13; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_13 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_13 FOR VALUES IN ('N');


--
-- Name: storage_tables_blobs_partition_14; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_14 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_14 FOR VALUES IN ('O');


--
-- Name: storage_tables_blobs_partition_15; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_15 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_15 FOR VALUES IN ('P');


--
-- Name: storage_tables_blobs_partition_16; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_16 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_16 FOR VALUES IN ('Q');


--
-- Name: storage_tables_blobs_partition_17; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_17 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_17 FOR VALUES IN ('R');


--
-- Name: storage_tables_blobs_partition_18; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_18 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_18 FOR VALUES IN ('S');


--
-- Name: storage_tables_blobs_partition_19; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_19 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_19 FOR VALUES IN ('T');


--
-- Name: storage_tables_blobs_partition_2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_2 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_2 FOR VALUES IN ('C');


--
-- Name: storage_tables_blobs_partition_20; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_20 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_20 FOR VALUES IN ('U');


--
-- Name: storage_tables_blobs_partition_21; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_21 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_21 FOR VALUES IN ('V');


--
-- Name: storage_tables_blobs_partition_22; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_22 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_22 FOR VALUES IN ('W');


--
-- Name: storage_tables_blobs_partition_23; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_23 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_23 FOR VALUES IN ('X');


--
-- Name: storage_tables_blobs_partition_24; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_24 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_24 FOR VALUES IN ('Y');


--
-- Name: storage_tables_blobs_partition_25; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_25 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_25 FOR VALUES IN ('Z');


--
-- Name: storage_tables_blobs_partition_26; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_26 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_26 FOR VALUES IN ('a');


--
-- Name: storage_tables_blobs_partition_27; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_27 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_27 FOR VALUES IN ('b');


--
-- Name: storage_tables_blobs_partition_28; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_28 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_28 FOR VALUES IN ('c');


--
-- Name: storage_tables_blobs_partition_29; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_29 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_29 FOR VALUES IN ('d');


--
-- Name: storage_tables_blobs_partition_3; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_3 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_3 FOR VALUES IN ('D');


--
-- Name: storage_tables_blobs_partition_30; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_30 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_30 FOR VALUES IN ('e');


--
-- Name: storage_tables_blobs_partition_31; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_31 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_31 FOR VALUES IN ('f');


--
-- Name: storage_tables_blobs_partition_32; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_32 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_32 FOR VALUES IN ('g');


--
-- Name: storage_tables_blobs_partition_33; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_33 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_33 FOR VALUES IN ('h');


--
-- Name: storage_tables_blobs_partition_34; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_34 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_34 FOR VALUES IN ('i');


--
-- Name: storage_tables_blobs_partition_35; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_35 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_35 FOR VALUES IN ('j');


--
-- Name: storage_tables_blobs_partition_36; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_36 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_36 FOR VALUES IN ('k');


--
-- Name: storage_tables_blobs_partition_37; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_37 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_37 FOR VALUES IN ('l');


--
-- Name: storage_tables_blobs_partition_38; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_38 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_38 FOR VALUES IN ('m');


--
-- Name: storage_tables_blobs_partition_39; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_39 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_39 FOR VALUES IN ('n');


--
-- Name: storage_tables_blobs_partition_4; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_4 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_4 FOR VALUES IN ('E');


--
-- Name: storage_tables_blobs_partition_40; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_40 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_40 FOR VALUES IN ('o');


--
-- Name: storage_tables_blobs_partition_41; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_41 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_41 FOR VALUES IN ('p');


--
-- Name: storage_tables_blobs_partition_42; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_42 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_42 FOR VALUES IN ('q');


--
-- Name: storage_tables_blobs_partition_43; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_43 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_43 FOR VALUES IN ('r');


--
-- Name: storage_tables_blobs_partition_44; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_44 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_44 FOR VALUES IN ('s');


--
-- Name: storage_tables_blobs_partition_45; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_45 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_45 FOR VALUES IN ('t');


--
-- Name: storage_tables_blobs_partition_46; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_46 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_46 FOR VALUES IN ('u');


--
-- Name: storage_tables_blobs_partition_47; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_47 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_47 FOR VALUES IN ('v');


--
-- Name: storage_tables_blobs_partition_48; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_48 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_48 FOR VALUES IN ('w');


--
-- Name: storage_tables_blobs_partition_49; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_49 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_49 FOR VALUES IN ('x');


--
-- Name: storage_tables_blobs_partition_5; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_5 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_5 FOR VALUES IN ('F');


--
-- Name: storage_tables_blobs_partition_50; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_50 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_50 FOR VALUES IN ('y');


--
-- Name: storage_tables_blobs_partition_51; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_51 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_51 FOR VALUES IN ('z');


--
-- Name: storage_tables_blobs_partition_52; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_52 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_52 FOR VALUES IN ('0');


--
-- Name: storage_tables_blobs_partition_53; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_53 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_53 FOR VALUES IN ('1');


--
-- Name: storage_tables_blobs_partition_54; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_54 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_54 FOR VALUES IN ('2');


--
-- Name: storage_tables_blobs_partition_55; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_55 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_55 FOR VALUES IN ('3');


--
-- Name: storage_tables_blobs_partition_56; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_56 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_56 FOR VALUES IN ('4');


--
-- Name: storage_tables_blobs_partition_57; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_57 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_57 FOR VALUES IN ('5');


--
-- Name: storage_tables_blobs_partition_58; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_58 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_58 FOR VALUES IN ('6');


--
-- Name: storage_tables_blobs_partition_59; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_59 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_59 FOR VALUES IN ('7');


--
-- Name: storage_tables_blobs_partition_6; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_6 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_6 FOR VALUES IN ('G');


--
-- Name: storage_tables_blobs_partition_60; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_60 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_60 FOR VALUES IN ('8');


--
-- Name: storage_tables_blobs_partition_61; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_61 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_61 FOR VALUES IN ('9');


--
-- Name: storage_tables_blobs_partition_62; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_62 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_62 FOR VALUES IN ('+');


--
-- Name: storage_tables_blobs_partition_63; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_63 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_63 FOR VALUES IN ('/');


--
-- Name: storage_tables_blobs_partition_7; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_7 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_7 FOR VALUES IN ('H');


--
-- Name: storage_tables_blobs_partition_8; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_8 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_8 FOR VALUES IN ('I');


--
-- Name: storage_tables_blobs_partition_9; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_9 (
    attachments_count integer DEFAULT 0 NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    filename character varying,
    partition_key character(1) NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_9 FOR VALUES IN ('J');


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
-- Name: storage_tables_blobs_partition_0_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_0_attachments_count_idx ON public.storage_tables_blobs_partition_0 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_0_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_0_partition_key_checksum_idx ON public.storage_tables_blobs_partition_0 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_10_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_10_attachments_count_idx ON public.storage_tables_blobs_partition_10 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_10_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_10_partition_key_checksum_idx ON public.storage_tables_blobs_partition_10 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_11_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_11_attachments_count_idx ON public.storage_tables_blobs_partition_11 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_11_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_11_partition_key_checksum_idx ON public.storage_tables_blobs_partition_11 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_12_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_12_attachments_count_idx ON public.storage_tables_blobs_partition_12 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_12_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_12_partition_key_checksum_idx ON public.storage_tables_blobs_partition_12 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_13_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_13_attachments_count_idx ON public.storage_tables_blobs_partition_13 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_13_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_13_partition_key_checksum_idx ON public.storage_tables_blobs_partition_13 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_14_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_14_attachments_count_idx ON public.storage_tables_blobs_partition_14 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_14_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_14_partition_key_checksum_idx ON public.storage_tables_blobs_partition_14 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_15_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_15_attachments_count_idx ON public.storage_tables_blobs_partition_15 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_15_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_15_partition_key_checksum_idx ON public.storage_tables_blobs_partition_15 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_16_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_16_attachments_count_idx ON public.storage_tables_blobs_partition_16 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_16_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_16_partition_key_checksum_idx ON public.storage_tables_blobs_partition_16 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_17_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_17_attachments_count_idx ON public.storage_tables_blobs_partition_17 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_17_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_17_partition_key_checksum_idx ON public.storage_tables_blobs_partition_17 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_18_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_18_attachments_count_idx ON public.storage_tables_blobs_partition_18 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_18_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_18_partition_key_checksum_idx ON public.storage_tables_blobs_partition_18 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_19_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_19_attachments_count_idx ON public.storage_tables_blobs_partition_19 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_19_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_19_partition_key_checksum_idx ON public.storage_tables_blobs_partition_19 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_1_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_1_attachments_count_idx ON public.storage_tables_blobs_partition_1 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_1_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_1_partition_key_checksum_idx ON public.storage_tables_blobs_partition_1 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_20_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_20_attachments_count_idx ON public.storage_tables_blobs_partition_20 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_20_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_20_partition_key_checksum_idx ON public.storage_tables_blobs_partition_20 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_21_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_21_attachments_count_idx ON public.storage_tables_blobs_partition_21 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_21_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_21_partition_key_checksum_idx ON public.storage_tables_blobs_partition_21 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_22_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_22_attachments_count_idx ON public.storage_tables_blobs_partition_22 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_22_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_22_partition_key_checksum_idx ON public.storage_tables_blobs_partition_22 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_23_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_23_attachments_count_idx ON public.storage_tables_blobs_partition_23 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_23_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_23_partition_key_checksum_idx ON public.storage_tables_blobs_partition_23 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_24_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_24_attachments_count_idx ON public.storage_tables_blobs_partition_24 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_24_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_24_partition_key_checksum_idx ON public.storage_tables_blobs_partition_24 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_25_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_25_attachments_count_idx ON public.storage_tables_blobs_partition_25 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_25_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_25_partition_key_checksum_idx ON public.storage_tables_blobs_partition_25 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_26_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_26_attachments_count_idx ON public.storage_tables_blobs_partition_26 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_26_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_26_partition_key_checksum_idx ON public.storage_tables_blobs_partition_26 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_27_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_27_attachments_count_idx ON public.storage_tables_blobs_partition_27 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_27_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_27_partition_key_checksum_idx ON public.storage_tables_blobs_partition_27 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_28_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_28_attachments_count_idx ON public.storage_tables_blobs_partition_28 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_28_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_28_partition_key_checksum_idx ON public.storage_tables_blobs_partition_28 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_29_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_29_attachments_count_idx ON public.storage_tables_blobs_partition_29 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_29_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_29_partition_key_checksum_idx ON public.storage_tables_blobs_partition_29 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_2_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_2_attachments_count_idx ON public.storage_tables_blobs_partition_2 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_2_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_2_partition_key_checksum_idx ON public.storage_tables_blobs_partition_2 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_30_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_30_attachments_count_idx ON public.storage_tables_blobs_partition_30 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_30_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_30_partition_key_checksum_idx ON public.storage_tables_blobs_partition_30 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_31_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_31_attachments_count_idx ON public.storage_tables_blobs_partition_31 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_31_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_31_partition_key_checksum_idx ON public.storage_tables_blobs_partition_31 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_32_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_32_attachments_count_idx ON public.storage_tables_blobs_partition_32 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_32_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_32_partition_key_checksum_idx ON public.storage_tables_blobs_partition_32 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_33_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_33_attachments_count_idx ON public.storage_tables_blobs_partition_33 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_33_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_33_partition_key_checksum_idx ON public.storage_tables_blobs_partition_33 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_34_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_34_attachments_count_idx ON public.storage_tables_blobs_partition_34 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_34_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_34_partition_key_checksum_idx ON public.storage_tables_blobs_partition_34 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_35_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_35_attachments_count_idx ON public.storage_tables_blobs_partition_35 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_35_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_35_partition_key_checksum_idx ON public.storage_tables_blobs_partition_35 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_36_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_36_attachments_count_idx ON public.storage_tables_blobs_partition_36 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_36_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_36_partition_key_checksum_idx ON public.storage_tables_blobs_partition_36 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_37_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_37_attachments_count_idx ON public.storage_tables_blobs_partition_37 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_37_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_37_partition_key_checksum_idx ON public.storage_tables_blobs_partition_37 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_38_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_38_attachments_count_idx ON public.storage_tables_blobs_partition_38 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_38_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_38_partition_key_checksum_idx ON public.storage_tables_blobs_partition_38 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_39_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_39_attachments_count_idx ON public.storage_tables_blobs_partition_39 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_39_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_39_partition_key_checksum_idx ON public.storage_tables_blobs_partition_39 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_3_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_3_attachments_count_idx ON public.storage_tables_blobs_partition_3 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_3_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_3_partition_key_checksum_idx ON public.storage_tables_blobs_partition_3 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_40_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_40_attachments_count_idx ON public.storage_tables_blobs_partition_40 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_40_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_40_partition_key_checksum_idx ON public.storage_tables_blobs_partition_40 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_41_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_41_attachments_count_idx ON public.storage_tables_blobs_partition_41 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_41_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_41_partition_key_checksum_idx ON public.storage_tables_blobs_partition_41 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_42_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_42_attachments_count_idx ON public.storage_tables_blobs_partition_42 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_42_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_42_partition_key_checksum_idx ON public.storage_tables_blobs_partition_42 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_43_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_43_attachments_count_idx ON public.storage_tables_blobs_partition_43 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_43_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_43_partition_key_checksum_idx ON public.storage_tables_blobs_partition_43 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_44_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_44_attachments_count_idx ON public.storage_tables_blobs_partition_44 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_44_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_44_partition_key_checksum_idx ON public.storage_tables_blobs_partition_44 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_45_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_45_attachments_count_idx ON public.storage_tables_blobs_partition_45 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_45_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_45_partition_key_checksum_idx ON public.storage_tables_blobs_partition_45 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_46_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_46_attachments_count_idx ON public.storage_tables_blobs_partition_46 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_46_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_46_partition_key_checksum_idx ON public.storage_tables_blobs_partition_46 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_47_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_47_attachments_count_idx ON public.storage_tables_blobs_partition_47 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_47_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_47_partition_key_checksum_idx ON public.storage_tables_blobs_partition_47 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_48_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_48_attachments_count_idx ON public.storage_tables_blobs_partition_48 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_48_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_48_partition_key_checksum_idx ON public.storage_tables_blobs_partition_48 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_49_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_49_attachments_count_idx ON public.storage_tables_blobs_partition_49 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_49_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_49_partition_key_checksum_idx ON public.storage_tables_blobs_partition_49 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_4_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_4_attachments_count_idx ON public.storage_tables_blobs_partition_4 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_4_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_4_partition_key_checksum_idx ON public.storage_tables_blobs_partition_4 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_50_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_50_attachments_count_idx ON public.storage_tables_blobs_partition_50 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_50_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_50_partition_key_checksum_idx ON public.storage_tables_blobs_partition_50 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_51_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_51_attachments_count_idx ON public.storage_tables_blobs_partition_51 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_51_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_51_partition_key_checksum_idx ON public.storage_tables_blobs_partition_51 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_52_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_52_attachments_count_idx ON public.storage_tables_blobs_partition_52 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_52_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_52_partition_key_checksum_idx ON public.storage_tables_blobs_partition_52 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_53_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_53_attachments_count_idx ON public.storage_tables_blobs_partition_53 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_53_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_53_partition_key_checksum_idx ON public.storage_tables_blobs_partition_53 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_54_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_54_attachments_count_idx ON public.storage_tables_blobs_partition_54 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_54_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_54_partition_key_checksum_idx ON public.storage_tables_blobs_partition_54 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_55_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_55_attachments_count_idx ON public.storage_tables_blobs_partition_55 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_55_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_55_partition_key_checksum_idx ON public.storage_tables_blobs_partition_55 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_56_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_56_attachments_count_idx ON public.storage_tables_blobs_partition_56 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_56_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_56_partition_key_checksum_idx ON public.storage_tables_blobs_partition_56 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_57_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_57_attachments_count_idx ON public.storage_tables_blobs_partition_57 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_57_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_57_partition_key_checksum_idx ON public.storage_tables_blobs_partition_57 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_58_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_58_attachments_count_idx ON public.storage_tables_blobs_partition_58 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_58_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_58_partition_key_checksum_idx ON public.storage_tables_blobs_partition_58 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_59_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_59_attachments_count_idx ON public.storage_tables_blobs_partition_59 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_59_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_59_partition_key_checksum_idx ON public.storage_tables_blobs_partition_59 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_5_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_5_attachments_count_idx ON public.storage_tables_blobs_partition_5 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_5_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_5_partition_key_checksum_idx ON public.storage_tables_blobs_partition_5 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_60_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_60_attachments_count_idx ON public.storage_tables_blobs_partition_60 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_60_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_60_partition_key_checksum_idx ON public.storage_tables_blobs_partition_60 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_61_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_61_attachments_count_idx ON public.storage_tables_blobs_partition_61 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_61_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_61_partition_key_checksum_idx ON public.storage_tables_blobs_partition_61 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_62_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_62_attachments_count_idx ON public.storage_tables_blobs_partition_62 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_62_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_62_partition_key_checksum_idx ON public.storage_tables_blobs_partition_62 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_63_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_63_attachments_count_idx ON public.storage_tables_blobs_partition_63 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_63_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_63_partition_key_checksum_idx ON public.storage_tables_blobs_partition_63 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_6_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_6_attachments_count_idx ON public.storage_tables_blobs_partition_6 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_6_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_6_partition_key_checksum_idx ON public.storage_tables_blobs_partition_6 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_7_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_7_attachments_count_idx ON public.storage_tables_blobs_partition_7 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_7_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_7_partition_key_checksum_idx ON public.storage_tables_blobs_partition_7 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_8_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_8_attachments_count_idx ON public.storage_tables_blobs_partition_8 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_8_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_8_partition_key_checksum_idx ON public.storage_tables_blobs_partition_8 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_9_attachments_count_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_9_attachments_count_idx ON public.storage_tables_blobs_partition_9 USING btree (attachments_count) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_9_partition_key_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX storage_tables_blobs_partition_9_partition_key_checksum_idx ON public.storage_tables_blobs_partition_9 USING btree (partition_key, checksum);


--
-- Name: storage_tables_blobs_partition_0_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_0_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_0_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_0_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_10_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_10_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_10_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_10_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_11_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_11_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_11_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_11_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_12_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_12_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_12_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_12_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_13_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_13_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_13_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_13_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_14_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_14_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_14_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_14_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_15_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_15_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_15_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_15_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_16_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_16_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_16_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_16_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_17_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_17_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_17_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_17_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_18_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_18_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_18_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_18_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_19_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_19_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_19_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_19_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_1_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_1_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_1_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_1_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_20_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_20_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_20_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_20_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_21_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_21_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_21_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_21_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_22_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_22_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_22_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_22_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_23_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_23_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_23_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_23_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_24_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_24_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_24_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_24_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_25_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_25_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_25_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_25_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_26_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_26_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_26_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_26_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_27_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_27_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_27_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_27_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_28_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_28_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_28_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_28_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_29_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_29_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_29_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_29_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_2_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_2_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_2_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_2_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_30_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_30_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_30_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_30_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_31_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_31_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_31_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_31_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_32_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_32_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_32_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_32_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_33_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_33_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_33_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_33_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_34_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_34_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_34_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_34_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_35_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_35_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_35_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_35_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_36_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_36_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_36_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_36_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_37_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_37_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_37_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_37_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_38_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_38_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_38_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_38_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_39_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_39_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_39_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_39_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_3_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_3_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_3_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_3_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_40_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_40_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_40_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_40_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_41_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_41_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_41_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_41_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_42_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_42_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_42_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_42_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_43_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_43_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_43_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_43_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_44_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_44_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_44_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_44_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_45_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_45_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_45_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_45_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_46_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_46_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_46_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_46_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_47_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_47_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_47_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_47_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_48_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_48_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_48_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_48_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_49_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_49_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_49_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_49_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_4_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_4_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_4_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_4_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_50_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_50_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_50_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_50_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_51_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_51_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_51_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_51_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_52_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_52_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_52_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_52_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_53_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_53_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_53_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_53_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_54_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_54_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_54_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_54_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_55_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_55_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_55_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_55_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_56_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_56_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_56_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_56_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_57_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_57_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_57_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_57_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_58_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_58_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_58_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_58_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_59_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_59_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_59_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_59_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_5_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_5_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_5_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_5_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_60_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_60_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_60_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_60_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_61_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_61_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_61_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_61_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_62_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_62_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_62_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_62_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_63_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_63_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_63_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_63_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_6_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_6_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_6_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_6_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_7_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_7_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_7_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_7_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_8_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_8_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_8_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_8_partition_key_checksum_idx;


--
-- Name: storage_tables_blobs_partition_9_attachments_count_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_attachments_count ATTACH PARTITION public.storage_tables_blobs_partition_9_attachments_count_idx;


--
-- Name: storage_tables_blobs_partition_9_partition_key_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_partition_key_and_checksum ATTACH PARTITION public.storage_tables_blobs_partition_9_partition_key_checksum_idx;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230911133621'),
('20230914064811'),
('20230914080339'),
('20230914102244');


