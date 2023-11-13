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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


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
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
)
PARTITION BY LIST (partition_key);


--
-- Name: storage_tables_blobs_partition_0; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_0 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_0 FOR VALUES IN ('A');


--
-- Name: storage_tables_blobs_partition_1; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_1 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_1 FOR VALUES IN ('B');


--
-- Name: storage_tables_blobs_partition_10; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_10 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_10 FOR VALUES IN ('K');


--
-- Name: storage_tables_blobs_partition_11; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_11 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_11 FOR VALUES IN ('L');


--
-- Name: storage_tables_blobs_partition_12; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_12 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_12 FOR VALUES IN ('M');


--
-- Name: storage_tables_blobs_partition_13; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_13 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_13 FOR VALUES IN ('N');


--
-- Name: storage_tables_blobs_partition_14; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_14 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_14 FOR VALUES IN ('O');


--
-- Name: storage_tables_blobs_partition_15; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_15 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_15 FOR VALUES IN ('P');


--
-- Name: storage_tables_blobs_partition_16; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_16 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_16 FOR VALUES IN ('Q');


--
-- Name: storage_tables_blobs_partition_17; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_17 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_17 FOR VALUES IN ('R');


--
-- Name: storage_tables_blobs_partition_18; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_18 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_18 FOR VALUES IN ('S');


--
-- Name: storage_tables_blobs_partition_19; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_19 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_19 FOR VALUES IN ('T');


--
-- Name: storage_tables_blobs_partition_2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_2 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_2 FOR VALUES IN ('C');


--
-- Name: storage_tables_blobs_partition_20; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_20 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_20 FOR VALUES IN ('U');


--
-- Name: storage_tables_blobs_partition_21; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_21 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_21 FOR VALUES IN ('V');


--
-- Name: storage_tables_blobs_partition_22; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_22 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_22 FOR VALUES IN ('W');


--
-- Name: storage_tables_blobs_partition_23; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_23 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_23 FOR VALUES IN ('X');


--
-- Name: storage_tables_blobs_partition_24; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_24 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_24 FOR VALUES IN ('Y');


--
-- Name: storage_tables_blobs_partition_25; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_25 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_25 FOR VALUES IN ('Z');


--
-- Name: storage_tables_blobs_partition_26; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_26 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_26 FOR VALUES IN ('a');


--
-- Name: storage_tables_blobs_partition_27; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_27 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_27 FOR VALUES IN ('b');


--
-- Name: storage_tables_blobs_partition_28; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_28 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_28 FOR VALUES IN ('c');


--
-- Name: storage_tables_blobs_partition_29; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_29 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_29 FOR VALUES IN ('d');


--
-- Name: storage_tables_blobs_partition_3; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_3 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_3 FOR VALUES IN ('D');


--
-- Name: storage_tables_blobs_partition_30; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_30 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_30 FOR VALUES IN ('e');


--
-- Name: storage_tables_blobs_partition_31; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_31 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_31 FOR VALUES IN ('f');


--
-- Name: storage_tables_blobs_partition_32; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_32 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_32 FOR VALUES IN ('g');


--
-- Name: storage_tables_blobs_partition_33; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_33 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_33 FOR VALUES IN ('h');


--
-- Name: storage_tables_blobs_partition_34; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_34 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_34 FOR VALUES IN ('i');


--
-- Name: storage_tables_blobs_partition_35; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_35 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_35 FOR VALUES IN ('j');


--
-- Name: storage_tables_blobs_partition_36; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_36 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_36 FOR VALUES IN ('k');


--
-- Name: storage_tables_blobs_partition_37; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_37 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_37 FOR VALUES IN ('l');


--
-- Name: storage_tables_blobs_partition_38; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_38 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_38 FOR VALUES IN ('m');


--
-- Name: storage_tables_blobs_partition_39; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_39 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_39 FOR VALUES IN ('n');


--
-- Name: storage_tables_blobs_partition_4; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_4 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_4 FOR VALUES IN ('E');


--
-- Name: storage_tables_blobs_partition_40; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_40 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_40 FOR VALUES IN ('o');


--
-- Name: storage_tables_blobs_partition_41; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_41 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_41 FOR VALUES IN ('p');


--
-- Name: storage_tables_blobs_partition_42; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_42 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_42 FOR VALUES IN ('q');


--
-- Name: storage_tables_blobs_partition_43; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_43 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_43 FOR VALUES IN ('r');


--
-- Name: storage_tables_blobs_partition_44; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_44 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_44 FOR VALUES IN ('s');


--
-- Name: storage_tables_blobs_partition_45; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_45 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_45 FOR VALUES IN ('t');


--
-- Name: storage_tables_blobs_partition_46; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_46 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_46 FOR VALUES IN ('u');


--
-- Name: storage_tables_blobs_partition_47; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_47 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_47 FOR VALUES IN ('v');


--
-- Name: storage_tables_blobs_partition_48; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_48 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_48 FOR VALUES IN ('w');


--
-- Name: storage_tables_blobs_partition_49; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_49 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_49 FOR VALUES IN ('x');


--
-- Name: storage_tables_blobs_partition_5; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_5 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_5 FOR VALUES IN ('F');


--
-- Name: storage_tables_blobs_partition_50; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_50 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_50 FOR VALUES IN ('y');


--
-- Name: storage_tables_blobs_partition_51; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_51 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_51 FOR VALUES IN ('z');


--
-- Name: storage_tables_blobs_partition_52; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_52 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_52 FOR VALUES IN ('0');


--
-- Name: storage_tables_blobs_partition_53; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_53 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_53 FOR VALUES IN ('1');


--
-- Name: storage_tables_blobs_partition_54; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_54 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_54 FOR VALUES IN ('2');


--
-- Name: storage_tables_blobs_partition_55; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_55 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_55 FOR VALUES IN ('3');


--
-- Name: storage_tables_blobs_partition_56; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_56 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_56 FOR VALUES IN ('4');


--
-- Name: storage_tables_blobs_partition_57; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_57 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_57 FOR VALUES IN ('5');


--
-- Name: storage_tables_blobs_partition_58; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_58 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_58 FOR VALUES IN ('6');


--
-- Name: storage_tables_blobs_partition_59; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_59 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_59 FOR VALUES IN ('7');


--
-- Name: storage_tables_blobs_partition_6; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_6 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_6 FOR VALUES IN ('G');


--
-- Name: storage_tables_blobs_partition_60; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_60 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_60 FOR VALUES IN ('8');


--
-- Name: storage_tables_blobs_partition_61; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_61 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_61 FOR VALUES IN ('9');


--
-- Name: storage_tables_blobs_partition_62; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_62 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_62 FOR VALUES IN ('+');


--
-- Name: storage_tables_blobs_partition_63; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_63 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_63 FOR VALUES IN ('/');


--
-- Name: storage_tables_blobs_partition_7; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_7 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_7 FOR VALUES IN ('H');


--
-- Name: storage_tables_blobs_partition_8; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_8 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_8 FOR VALUES IN ('I');


--
-- Name: storage_tables_blobs_partition_9; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storage_tables_blobs_partition_9 (
    partition_key character(1) NOT NULL,
    checksum character(86) NOT NULL,
    attachments_count_modified timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    attachments_count integer DEFAULT 0 NOT NULL,
    byte_size bigint NOT NULL,
    content_type character varying,
    metadata jsonb,
    CONSTRAINT partition_key_is_checksum_first_letter CHECK (((partition_key)::text = "left"((checksum)::text, 1)))
);
ALTER TABLE ONLY public.storage_tables_blobs ATTACH PARTITION public.storage_tables_blobs_partition_9 FOR VALUES IN ('J');


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


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
-- Name: storage_tables_blobs storage_tables_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs
    ADD CONSTRAINT storage_tables_blobs_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_0 storage_tables_blobs_partition_0_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_0
    ADD CONSTRAINT storage_tables_blobs_partition_0_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_10 storage_tables_blobs_partition_10_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_10
    ADD CONSTRAINT storage_tables_blobs_partition_10_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_11 storage_tables_blobs_partition_11_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_11
    ADD CONSTRAINT storage_tables_blobs_partition_11_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_12 storage_tables_blobs_partition_12_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_12
    ADD CONSTRAINT storage_tables_blobs_partition_12_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_13 storage_tables_blobs_partition_13_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_13
    ADD CONSTRAINT storage_tables_blobs_partition_13_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_14 storage_tables_blobs_partition_14_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_14
    ADD CONSTRAINT storage_tables_blobs_partition_14_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_15 storage_tables_blobs_partition_15_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_15
    ADD CONSTRAINT storage_tables_blobs_partition_15_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_16 storage_tables_blobs_partition_16_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_16
    ADD CONSTRAINT storage_tables_blobs_partition_16_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_17 storage_tables_blobs_partition_17_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_17
    ADD CONSTRAINT storage_tables_blobs_partition_17_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_18 storage_tables_blobs_partition_18_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_18
    ADD CONSTRAINT storage_tables_blobs_partition_18_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_19 storage_tables_blobs_partition_19_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_19
    ADD CONSTRAINT storage_tables_blobs_partition_19_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_1 storage_tables_blobs_partition_1_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_1
    ADD CONSTRAINT storage_tables_blobs_partition_1_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_20 storage_tables_blobs_partition_20_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_20
    ADD CONSTRAINT storage_tables_blobs_partition_20_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_21 storage_tables_blobs_partition_21_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_21
    ADD CONSTRAINT storage_tables_blobs_partition_21_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_22 storage_tables_blobs_partition_22_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_22
    ADD CONSTRAINT storage_tables_blobs_partition_22_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_23 storage_tables_blobs_partition_23_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_23
    ADD CONSTRAINT storage_tables_blobs_partition_23_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_24 storage_tables_blobs_partition_24_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_24
    ADD CONSTRAINT storage_tables_blobs_partition_24_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_25 storage_tables_blobs_partition_25_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_25
    ADD CONSTRAINT storage_tables_blobs_partition_25_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_26 storage_tables_blobs_partition_26_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_26
    ADD CONSTRAINT storage_tables_blobs_partition_26_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_27 storage_tables_blobs_partition_27_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_27
    ADD CONSTRAINT storage_tables_blobs_partition_27_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_28 storage_tables_blobs_partition_28_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_28
    ADD CONSTRAINT storage_tables_blobs_partition_28_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_29 storage_tables_blobs_partition_29_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_29
    ADD CONSTRAINT storage_tables_blobs_partition_29_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_2 storage_tables_blobs_partition_2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_2
    ADD CONSTRAINT storage_tables_blobs_partition_2_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_30 storage_tables_blobs_partition_30_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_30
    ADD CONSTRAINT storage_tables_blobs_partition_30_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_31 storage_tables_blobs_partition_31_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_31
    ADD CONSTRAINT storage_tables_blobs_partition_31_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_32 storage_tables_blobs_partition_32_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_32
    ADD CONSTRAINT storage_tables_blobs_partition_32_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_33 storage_tables_blobs_partition_33_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_33
    ADD CONSTRAINT storage_tables_blobs_partition_33_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_34 storage_tables_blobs_partition_34_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_34
    ADD CONSTRAINT storage_tables_blobs_partition_34_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_35 storage_tables_blobs_partition_35_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_35
    ADD CONSTRAINT storage_tables_blobs_partition_35_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_36 storage_tables_blobs_partition_36_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_36
    ADD CONSTRAINT storage_tables_blobs_partition_36_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_37 storage_tables_blobs_partition_37_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_37
    ADD CONSTRAINT storage_tables_blobs_partition_37_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_38 storage_tables_blobs_partition_38_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_38
    ADD CONSTRAINT storage_tables_blobs_partition_38_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_39 storage_tables_blobs_partition_39_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_39
    ADD CONSTRAINT storage_tables_blobs_partition_39_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_3 storage_tables_blobs_partition_3_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_3
    ADD CONSTRAINT storage_tables_blobs_partition_3_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_40 storage_tables_blobs_partition_40_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_40
    ADD CONSTRAINT storage_tables_blobs_partition_40_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_41 storage_tables_blobs_partition_41_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_41
    ADD CONSTRAINT storage_tables_blobs_partition_41_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_42 storage_tables_blobs_partition_42_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_42
    ADD CONSTRAINT storage_tables_blobs_partition_42_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_43 storage_tables_blobs_partition_43_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_43
    ADD CONSTRAINT storage_tables_blobs_partition_43_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_44 storage_tables_blobs_partition_44_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_44
    ADD CONSTRAINT storage_tables_blobs_partition_44_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_45 storage_tables_blobs_partition_45_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_45
    ADD CONSTRAINT storage_tables_blobs_partition_45_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_46 storage_tables_blobs_partition_46_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_46
    ADD CONSTRAINT storage_tables_blobs_partition_46_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_47 storage_tables_blobs_partition_47_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_47
    ADD CONSTRAINT storage_tables_blobs_partition_47_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_48 storage_tables_blobs_partition_48_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_48
    ADD CONSTRAINT storage_tables_blobs_partition_48_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_49 storage_tables_blobs_partition_49_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_49
    ADD CONSTRAINT storage_tables_blobs_partition_49_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_4 storage_tables_blobs_partition_4_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_4
    ADD CONSTRAINT storage_tables_blobs_partition_4_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_50 storage_tables_blobs_partition_50_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_50
    ADD CONSTRAINT storage_tables_blobs_partition_50_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_51 storage_tables_blobs_partition_51_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_51
    ADD CONSTRAINT storage_tables_blobs_partition_51_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_52 storage_tables_blobs_partition_52_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_52
    ADD CONSTRAINT storage_tables_blobs_partition_52_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_53 storage_tables_blobs_partition_53_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_53
    ADD CONSTRAINT storage_tables_blobs_partition_53_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_54 storage_tables_blobs_partition_54_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_54
    ADD CONSTRAINT storage_tables_blobs_partition_54_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_55 storage_tables_blobs_partition_55_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_55
    ADD CONSTRAINT storage_tables_blobs_partition_55_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_56 storage_tables_blobs_partition_56_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_56
    ADD CONSTRAINT storage_tables_blobs_partition_56_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_57 storage_tables_blobs_partition_57_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_57
    ADD CONSTRAINT storage_tables_blobs_partition_57_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_58 storage_tables_blobs_partition_58_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_58
    ADD CONSTRAINT storage_tables_blobs_partition_58_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_59 storage_tables_blobs_partition_59_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_59
    ADD CONSTRAINT storage_tables_blobs_partition_59_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_5 storage_tables_blobs_partition_5_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_5
    ADD CONSTRAINT storage_tables_blobs_partition_5_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_60 storage_tables_blobs_partition_60_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_60
    ADD CONSTRAINT storage_tables_blobs_partition_60_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_61 storage_tables_blobs_partition_61_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_61
    ADD CONSTRAINT storage_tables_blobs_partition_61_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_62 storage_tables_blobs_partition_62_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_62
    ADD CONSTRAINT storage_tables_blobs_partition_62_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_63 storage_tables_blobs_partition_63_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_63
    ADD CONSTRAINT storage_tables_blobs_partition_63_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_6 storage_tables_blobs_partition_6_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_6
    ADD CONSTRAINT storage_tables_blobs_partition_6_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_7 storage_tables_blobs_partition_7_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_7
    ADD CONSTRAINT storage_tables_blobs_partition_7_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_8 storage_tables_blobs_partition_8_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_8
    ADD CONSTRAINT storage_tables_blobs_partition_8_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: storage_tables_blobs_partition_9 storage_tables_blobs_partition_9_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storage_tables_blobs_partition_9
    ADD CONSTRAINT storage_tables_blobs_partition_9_pkey PRIMARY KEY (checksum, partition_key);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_storage_tables_blobs_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_storage_tables_blobs_on_checksum ON ONLY public.storage_tables_blobs USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_0_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_0_checksum_idx ON public.storage_tables_blobs_partition_0 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_10_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_10_checksum_idx ON public.storage_tables_blobs_partition_10 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_11_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_11_checksum_idx ON public.storage_tables_blobs_partition_11 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_12_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_12_checksum_idx ON public.storage_tables_blobs_partition_12 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_13_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_13_checksum_idx ON public.storage_tables_blobs_partition_13 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_14_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_14_checksum_idx ON public.storage_tables_blobs_partition_14 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_15_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_15_checksum_idx ON public.storage_tables_blobs_partition_15 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_16_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_16_checksum_idx ON public.storage_tables_blobs_partition_16 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_17_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_17_checksum_idx ON public.storage_tables_blobs_partition_17 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_18_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_18_checksum_idx ON public.storage_tables_blobs_partition_18 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_19_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_19_checksum_idx ON public.storage_tables_blobs_partition_19 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_1_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_1_checksum_idx ON public.storage_tables_blobs_partition_1 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_20_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_20_checksum_idx ON public.storage_tables_blobs_partition_20 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_21_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_21_checksum_idx ON public.storage_tables_blobs_partition_21 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_22_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_22_checksum_idx ON public.storage_tables_blobs_partition_22 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_23_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_23_checksum_idx ON public.storage_tables_blobs_partition_23 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_24_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_24_checksum_idx ON public.storage_tables_blobs_partition_24 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_25_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_25_checksum_idx ON public.storage_tables_blobs_partition_25 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_26_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_26_checksum_idx ON public.storage_tables_blobs_partition_26 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_27_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_27_checksum_idx ON public.storage_tables_blobs_partition_27 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_28_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_28_checksum_idx ON public.storage_tables_blobs_partition_28 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_29_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_29_checksum_idx ON public.storage_tables_blobs_partition_29 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_2_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_2_checksum_idx ON public.storage_tables_blobs_partition_2 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_30_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_30_checksum_idx ON public.storage_tables_blobs_partition_30 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_31_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_31_checksum_idx ON public.storage_tables_blobs_partition_31 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_32_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_32_checksum_idx ON public.storage_tables_blobs_partition_32 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_33_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_33_checksum_idx ON public.storage_tables_blobs_partition_33 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_34_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_34_checksum_idx ON public.storage_tables_blobs_partition_34 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_35_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_35_checksum_idx ON public.storage_tables_blobs_partition_35 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_36_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_36_checksum_idx ON public.storage_tables_blobs_partition_36 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_37_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_37_checksum_idx ON public.storage_tables_blobs_partition_37 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_38_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_38_checksum_idx ON public.storage_tables_blobs_partition_38 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_39_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_39_checksum_idx ON public.storage_tables_blobs_partition_39 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_3_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_3_checksum_idx ON public.storage_tables_blobs_partition_3 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_40_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_40_checksum_idx ON public.storage_tables_blobs_partition_40 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_41_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_41_checksum_idx ON public.storage_tables_blobs_partition_41 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_42_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_42_checksum_idx ON public.storage_tables_blobs_partition_42 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_43_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_43_checksum_idx ON public.storage_tables_blobs_partition_43 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_44_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_44_checksum_idx ON public.storage_tables_blobs_partition_44 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_45_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_45_checksum_idx ON public.storage_tables_blobs_partition_45 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_46_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_46_checksum_idx ON public.storage_tables_blobs_partition_46 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_47_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_47_checksum_idx ON public.storage_tables_blobs_partition_47 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_48_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_48_checksum_idx ON public.storage_tables_blobs_partition_48 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_49_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_49_checksum_idx ON public.storage_tables_blobs_partition_49 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_4_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_4_checksum_idx ON public.storage_tables_blobs_partition_4 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_50_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_50_checksum_idx ON public.storage_tables_blobs_partition_50 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_51_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_51_checksum_idx ON public.storage_tables_blobs_partition_51 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_52_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_52_checksum_idx ON public.storage_tables_blobs_partition_52 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_53_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_53_checksum_idx ON public.storage_tables_blobs_partition_53 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_54_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_54_checksum_idx ON public.storage_tables_blobs_partition_54 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_55_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_55_checksum_idx ON public.storage_tables_blobs_partition_55 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_56_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_56_checksum_idx ON public.storage_tables_blobs_partition_56 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_57_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_57_checksum_idx ON public.storage_tables_blobs_partition_57 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_58_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_58_checksum_idx ON public.storage_tables_blobs_partition_58 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_59_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_59_checksum_idx ON public.storage_tables_blobs_partition_59 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_5_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_5_checksum_idx ON public.storage_tables_blobs_partition_5 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_60_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_60_checksum_idx ON public.storage_tables_blobs_partition_60 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_61_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_61_checksum_idx ON public.storage_tables_blobs_partition_61 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_62_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_62_checksum_idx ON public.storage_tables_blobs_partition_62 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_63_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_63_checksum_idx ON public.storage_tables_blobs_partition_63 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_6_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_6_checksum_idx ON public.storage_tables_blobs_partition_6 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_7_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_7_checksum_idx ON public.storage_tables_blobs_partition_7 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_8_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_8_checksum_idx ON public.storage_tables_blobs_partition_8 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_9_checksum_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_tables_blobs_partition_9_checksum_idx ON public.storage_tables_blobs_partition_9 USING btree (checksum) WHERE (attachments_count = 0);


--
-- Name: storage_tables_blobs_partition_0_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_0_checksum_idx;


--
-- Name: storage_tables_blobs_partition_0_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_0_pkey;


--
-- Name: storage_tables_blobs_partition_10_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_10_checksum_idx;


--
-- Name: storage_tables_blobs_partition_10_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_10_pkey;


--
-- Name: storage_tables_blobs_partition_11_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_11_checksum_idx;


--
-- Name: storage_tables_blobs_partition_11_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_11_pkey;


--
-- Name: storage_tables_blobs_partition_12_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_12_checksum_idx;


--
-- Name: storage_tables_blobs_partition_12_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_12_pkey;


--
-- Name: storage_tables_blobs_partition_13_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_13_checksum_idx;


--
-- Name: storage_tables_blobs_partition_13_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_13_pkey;


--
-- Name: storage_tables_blobs_partition_14_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_14_checksum_idx;


--
-- Name: storage_tables_blobs_partition_14_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_14_pkey;


--
-- Name: storage_tables_blobs_partition_15_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_15_checksum_idx;


--
-- Name: storage_tables_blobs_partition_15_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_15_pkey;


--
-- Name: storage_tables_blobs_partition_16_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_16_checksum_idx;


--
-- Name: storage_tables_blobs_partition_16_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_16_pkey;


--
-- Name: storage_tables_blobs_partition_17_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_17_checksum_idx;


--
-- Name: storage_tables_blobs_partition_17_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_17_pkey;


--
-- Name: storage_tables_blobs_partition_18_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_18_checksum_idx;


--
-- Name: storage_tables_blobs_partition_18_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_18_pkey;


--
-- Name: storage_tables_blobs_partition_19_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_19_checksum_idx;


--
-- Name: storage_tables_blobs_partition_19_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_19_pkey;


--
-- Name: storage_tables_blobs_partition_1_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_1_checksum_idx;


--
-- Name: storage_tables_blobs_partition_1_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_1_pkey;


--
-- Name: storage_tables_blobs_partition_20_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_20_checksum_idx;


--
-- Name: storage_tables_blobs_partition_20_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_20_pkey;


--
-- Name: storage_tables_blobs_partition_21_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_21_checksum_idx;


--
-- Name: storage_tables_blobs_partition_21_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_21_pkey;


--
-- Name: storage_tables_blobs_partition_22_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_22_checksum_idx;


--
-- Name: storage_tables_blobs_partition_22_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_22_pkey;


--
-- Name: storage_tables_blobs_partition_23_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_23_checksum_idx;


--
-- Name: storage_tables_blobs_partition_23_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_23_pkey;


--
-- Name: storage_tables_blobs_partition_24_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_24_checksum_idx;


--
-- Name: storage_tables_blobs_partition_24_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_24_pkey;


--
-- Name: storage_tables_blobs_partition_25_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_25_checksum_idx;


--
-- Name: storage_tables_blobs_partition_25_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_25_pkey;


--
-- Name: storage_tables_blobs_partition_26_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_26_checksum_idx;


--
-- Name: storage_tables_blobs_partition_26_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_26_pkey;


--
-- Name: storage_tables_blobs_partition_27_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_27_checksum_idx;


--
-- Name: storage_tables_blobs_partition_27_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_27_pkey;


--
-- Name: storage_tables_blobs_partition_28_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_28_checksum_idx;


--
-- Name: storage_tables_blobs_partition_28_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_28_pkey;


--
-- Name: storage_tables_blobs_partition_29_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_29_checksum_idx;


--
-- Name: storage_tables_blobs_partition_29_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_29_pkey;


--
-- Name: storage_tables_blobs_partition_2_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_2_checksum_idx;


--
-- Name: storage_tables_blobs_partition_2_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_2_pkey;


--
-- Name: storage_tables_blobs_partition_30_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_30_checksum_idx;


--
-- Name: storage_tables_blobs_partition_30_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_30_pkey;


--
-- Name: storage_tables_blobs_partition_31_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_31_checksum_idx;


--
-- Name: storage_tables_blobs_partition_31_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_31_pkey;


--
-- Name: storage_tables_blobs_partition_32_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_32_checksum_idx;


--
-- Name: storage_tables_blobs_partition_32_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_32_pkey;


--
-- Name: storage_tables_blobs_partition_33_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_33_checksum_idx;


--
-- Name: storage_tables_blobs_partition_33_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_33_pkey;


--
-- Name: storage_tables_blobs_partition_34_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_34_checksum_idx;


--
-- Name: storage_tables_blobs_partition_34_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_34_pkey;


--
-- Name: storage_tables_blobs_partition_35_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_35_checksum_idx;


--
-- Name: storage_tables_blobs_partition_35_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_35_pkey;


--
-- Name: storage_tables_blobs_partition_36_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_36_checksum_idx;


--
-- Name: storage_tables_blobs_partition_36_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_36_pkey;


--
-- Name: storage_tables_blobs_partition_37_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_37_checksum_idx;


--
-- Name: storage_tables_blobs_partition_37_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_37_pkey;


--
-- Name: storage_tables_blobs_partition_38_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_38_checksum_idx;


--
-- Name: storage_tables_blobs_partition_38_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_38_pkey;


--
-- Name: storage_tables_blobs_partition_39_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_39_checksum_idx;


--
-- Name: storage_tables_blobs_partition_39_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_39_pkey;


--
-- Name: storage_tables_blobs_partition_3_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_3_checksum_idx;


--
-- Name: storage_tables_blobs_partition_3_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_3_pkey;


--
-- Name: storage_tables_blobs_partition_40_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_40_checksum_idx;


--
-- Name: storage_tables_blobs_partition_40_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_40_pkey;


--
-- Name: storage_tables_blobs_partition_41_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_41_checksum_idx;


--
-- Name: storage_tables_blobs_partition_41_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_41_pkey;


--
-- Name: storage_tables_blobs_partition_42_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_42_checksum_idx;


--
-- Name: storage_tables_blobs_partition_42_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_42_pkey;


--
-- Name: storage_tables_blobs_partition_43_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_43_checksum_idx;


--
-- Name: storage_tables_blobs_partition_43_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_43_pkey;


--
-- Name: storage_tables_blobs_partition_44_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_44_checksum_idx;


--
-- Name: storage_tables_blobs_partition_44_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_44_pkey;


--
-- Name: storage_tables_blobs_partition_45_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_45_checksum_idx;


--
-- Name: storage_tables_blobs_partition_45_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_45_pkey;


--
-- Name: storage_tables_blobs_partition_46_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_46_checksum_idx;


--
-- Name: storage_tables_blobs_partition_46_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_46_pkey;


--
-- Name: storage_tables_blobs_partition_47_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_47_checksum_idx;


--
-- Name: storage_tables_blobs_partition_47_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_47_pkey;


--
-- Name: storage_tables_blobs_partition_48_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_48_checksum_idx;


--
-- Name: storage_tables_blobs_partition_48_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_48_pkey;


--
-- Name: storage_tables_blobs_partition_49_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_49_checksum_idx;


--
-- Name: storage_tables_blobs_partition_49_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_49_pkey;


--
-- Name: storage_tables_blobs_partition_4_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_4_checksum_idx;


--
-- Name: storage_tables_blobs_partition_4_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_4_pkey;


--
-- Name: storage_tables_blobs_partition_50_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_50_checksum_idx;


--
-- Name: storage_tables_blobs_partition_50_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_50_pkey;


--
-- Name: storage_tables_blobs_partition_51_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_51_checksum_idx;


--
-- Name: storage_tables_blobs_partition_51_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_51_pkey;


--
-- Name: storage_tables_blobs_partition_52_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_52_checksum_idx;


--
-- Name: storage_tables_blobs_partition_52_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_52_pkey;


--
-- Name: storage_tables_blobs_partition_53_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_53_checksum_idx;


--
-- Name: storage_tables_blobs_partition_53_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_53_pkey;


--
-- Name: storage_tables_blobs_partition_54_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_54_checksum_idx;


--
-- Name: storage_tables_blobs_partition_54_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_54_pkey;


--
-- Name: storage_tables_blobs_partition_55_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_55_checksum_idx;


--
-- Name: storage_tables_blobs_partition_55_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_55_pkey;


--
-- Name: storage_tables_blobs_partition_56_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_56_checksum_idx;


--
-- Name: storage_tables_blobs_partition_56_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_56_pkey;


--
-- Name: storage_tables_blobs_partition_57_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_57_checksum_idx;


--
-- Name: storage_tables_blobs_partition_57_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_57_pkey;


--
-- Name: storage_tables_blobs_partition_58_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_58_checksum_idx;


--
-- Name: storage_tables_blobs_partition_58_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_58_pkey;


--
-- Name: storage_tables_blobs_partition_59_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_59_checksum_idx;


--
-- Name: storage_tables_blobs_partition_59_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_59_pkey;


--
-- Name: storage_tables_blobs_partition_5_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_5_checksum_idx;


--
-- Name: storage_tables_blobs_partition_5_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_5_pkey;


--
-- Name: storage_tables_blobs_partition_60_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_60_checksum_idx;


--
-- Name: storage_tables_blobs_partition_60_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_60_pkey;


--
-- Name: storage_tables_blobs_partition_61_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_61_checksum_idx;


--
-- Name: storage_tables_blobs_partition_61_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_61_pkey;


--
-- Name: storage_tables_blobs_partition_62_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_62_checksum_idx;


--
-- Name: storage_tables_blobs_partition_62_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_62_pkey;


--
-- Name: storage_tables_blobs_partition_63_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_63_checksum_idx;


--
-- Name: storage_tables_blobs_partition_63_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_63_pkey;


--
-- Name: storage_tables_blobs_partition_6_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_6_checksum_idx;


--
-- Name: storage_tables_blobs_partition_6_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_6_pkey;


--
-- Name: storage_tables_blobs_partition_7_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_7_checksum_idx;


--
-- Name: storage_tables_blobs_partition_7_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_7_pkey;


--
-- Name: storage_tables_blobs_partition_8_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_8_checksum_idx;


--
-- Name: storage_tables_blobs_partition_8_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_8_pkey;


--
-- Name: storage_tables_blobs_partition_9_checksum_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.index_storage_tables_blobs_on_checksum ATTACH PARTITION public.storage_tables_blobs_partition_9_checksum_idx;


--
-- Name: storage_tables_blobs_partition_9_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.storage_tables_blobs_pkey ATTACH PARTITION public.storage_tables_blobs_partition_9_pkey;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20231005134835'),
('20230914102244'),
('20230914080339'),
('20230914064811'),
('20230911133621');

