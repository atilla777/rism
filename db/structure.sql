SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: custom_field_data_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.custom_field_data_type AS ENUM (
    'string',
    'text',
    'datetime',
    'number',
    'boolean'
);


--
-- Name: indicator_content_format; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.indicator_content_format AS ENUM (
    'other',
    'network_service',
    'network',
    'network_port',
    'email_adress',
    'email_author',
    'email_theme',
    'email_content',
    'uri',
    'domain',
    'md5',
    'sha256',
    'sha512',
    'filename',
    'filesize',
    'process',
    'account'
);


--
-- Name: indicator_purpose; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.indicator_purpose AS ENUM (
    'not_set',
    'for_detect',
    'for_prevent'
);


--
-- Name: indicator_trust_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.indicator_trust_level AS ENUM (
    'not_set',
    'low',
    'high'
);


--
-- Name: vuln_actuality; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_actuality AS ENUM (
    'not_set',
    'actual',
    'not_actual'
);


--
-- Name: vuln_feed; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_feed AS ENUM (
    'custom',
    'nvd'
);


--
-- Name: vuln_relevance; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_relevance AS ENUM (
    'not_set',
    'relevant',
    'not_relevant'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agreement_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agreement_kinds (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: agreement_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agreement_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agreement_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agreement_kinds_id_seq OWNED BY public.agreement_kinds.id;


--
-- Name: agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agreements (
    id bigint NOT NULL,
    beginning date,
    prop character varying,
    duration integer,
    prolongation boolean,
    organization_id bigint,
    contractor_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agreement_kind_id bigint
);


--
-- Name: agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agreements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agreements_id_seq OWNED BY public.agreements.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    user_id bigint,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: attachment_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachment_links (
    id bigint NOT NULL,
    record_type character varying,
    record_id bigint,
    attachment_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachment_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachment_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachment_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachment_links_id_seq OWNED BY public.attachment_links.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    document character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ckeditor_assets (
    id integer NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    type character varying(30),
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ckeditor_assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ckeditor_assets_id_seq OWNED BY public.ckeditor_assets.id;


--
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_fields (
    id bigint NOT NULL,
    name character varying,
    data_type public.custom_field_data_type,
    field_model character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_fields_id_seq OWNED BY public.custom_fields.id;


--
-- Name: delivery_list_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_list_members (
    id bigint NOT NULL,
    organization_id bigint,
    delivery_list_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delivery_list_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_list_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_list_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_list_members_id_seq OWNED BY public.delivery_list_members.id;


--
-- Name: delivery_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_lists (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delivery_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_lists_id_seq OWNED BY public.delivery_lists.id;


--
-- Name: delivery_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_subjects (
    id bigint NOT NULL,
    deliverable_type character varying,
    deliverable_id bigint,
    delivery_list_id bigint,
    sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delivery_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_subjects_id_seq OWNED BY public.delivery_subjects.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    parent_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rank integer
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feeds (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feeds_id_seq OWNED BY public.feeds.id;


--
-- Name: host_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.host_services (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    host_id bigint,
    port integer,
    protocol character varying,
    legality integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vulnerable boolean,
    vuln_description text
);


--
-- Name: host_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.host_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: host_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.host_services_id_seq OWNED BY public.host_services.id;


--
-- Name: hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hosts (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    ip cidr,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hosts_id_seq OWNED BY public.hosts.id;


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incidents (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    user_id integer,
    discovered_at timestamp without time zone,
    discovered_time boolean DEFAULT false,
    started_at timestamp without time zone,
    started_time boolean DEFAULT false,
    finished_at timestamp without time zone,
    finished_time boolean DEFAULT false,
    closed_at timestamp without time zone,
    event_description text,
    investigation_description text,
    action_description text,
    severity integer,
    damage integer,
    state integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;


--
-- Name: indicator_context_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.indicator_context_members (
    id bigint NOT NULL,
    indicator_id bigint,
    indicator_context_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: indicator_context_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.indicator_context_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: indicator_context_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.indicator_context_members_id_seq OWNED BY public.indicator_context_members.id;


--
-- Name: indicator_contexts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.indicator_contexts (
    id bigint NOT NULL,
    name character varying,
    codename character varying,
    indicators_formats text[],
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: indicator_contexts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.indicator_contexts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: indicator_contexts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.indicator_contexts_id_seq OWNED BY public.indicator_contexts.id;


--
-- Name: indicators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.indicators (
    id bigint NOT NULL,
    user_id bigint,
    investigation_id bigint,
    trust_level public.indicator_trust_level DEFAULT 'not_set'::public.indicator_trust_level,
    content character varying,
    content_format public.indicator_content_format,
    purpose public.indicator_purpose DEFAULT 'not_set'::public.indicator_purpose,
    description text,
    enrichment jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.indicators_id_seq OWNED BY public.indicators.id;


--
-- Name: investigation_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.investigation_kinds (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: investigation_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.investigation_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: investigation_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.investigation_kinds_id_seq OWNED BY public.investigation_kinds.id;


--
-- Name: investigations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.investigations (
    id bigint NOT NULL,
    name character varying,
    user_id bigint,
    organization_id bigint,
    investigation_kind_id bigint,
    feed_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: investigations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.investigations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: investigations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.investigations_id_seq OWNED BY public.investigations.id;


--
-- Name: link_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.link_kinds (
    id bigint NOT NULL,
    name character varying,
    code_name character varying,
    rank integer,
    first_record_type character varying,
    second_record_type character varying,
    equal boolean,
    color character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: link_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.link_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.link_kinds_id_seq OWNED BY public.link_kinds.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.links (
    id bigint NOT NULL,
    first_record_type character varying,
    first_record_id bigint,
    second_record_type character varying,
    second_record_id bigint,
    link_kind_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.links_id_seq OWNED BY public.links.id;


--
-- Name: organization_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_kinds (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_kinds_id_seq OWNED BY public.organization_kinds.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id bigint,
    full_name character varying,
    organization_kind_id bigint
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id bigint NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: record_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.record_templates (
    id bigint NOT NULL,
    name character varying,
    record_content character varying,
    record_type character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: record_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.record_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: record_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.record_templates_id_seq OWNED BY public.record_templates.id;


--
-- Name: rights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rights (
    id bigint NOT NULL,
    role_id bigint,
    subject_type character varying,
    subject_id bigint,
    level integer,
    inherit boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id bigint
);


--
-- Name: rights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rights_id_seq OWNED BY public.rights.id;


--
-- Name: role_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_members (
    id bigint NOT NULL,
    user_id bigint,
    role_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: role_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_members_id_seq OWNED BY public.role_members.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: scan_job_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scan_job_logs (
    id bigint NOT NULL,
    scan_job_id bigint,
    jid character varying,
    queue character varying,
    start timestamp without time zone,
    finish timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scan_job_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scan_job_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scan_job_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scan_job_logs_id_seq OWNED BY public.scan_job_logs.id;


--
-- Name: scan_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scan_jobs (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    scan_engine character varying,
    scan_option_id bigint,
    hosts character varying,
    ports character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scan_jobs_hosts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scan_jobs_hosts (
    id bigint NOT NULL,
    scan_job_id bigint,
    host_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scan_jobs_hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scan_jobs_hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scan_jobs_hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scan_jobs_hosts_id_seq OWNED BY public.scan_jobs_hosts.id;


--
-- Name: scan_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scan_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scan_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scan_jobs_id_seq OWNED BY public.scan_jobs.id;


--
-- Name: scan_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scan_options (
    id bigint NOT NULL,
    name character varying,
    options jsonb,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    queue_number integer
);


--
-- Name: scan_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scan_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scan_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scan_options_id_seq OWNED BY public.scan_options.id;


--
-- Name: scan_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scan_results (
    id bigint NOT NULL,
    scan_job_id bigint,
    job_start timestamp without time zone,
    start timestamp without time zone,
    finished timestamp without time zone,
    scanned_ports character varying,
    ip cidr,
    port integer,
    protocol character varying,
    state integer,
    service character varying,
    legality integer,
    product character varying,
    product_version character varying,
    product_extrainfo character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_ip character varying,
    scan_engine character varying,
    jid character varying,
    vulners jsonb DEFAULT '[]'::jsonb NOT NULL
);


--
-- Name: scan_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scan_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scan_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scan_results_id_seq OWNED BY public.scan_results.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id bigint NOT NULL,
    job_type character varying,
    job_id bigint,
    minutes integer[] DEFAULT '{}'::integer[],
    hours integer[] DEFAULT '{}'::integer[],
    month_days integer[] DEFAULT '{}'::integer[],
    months integer[] DEFAULT '{}'::integer[],
    week_days integer[] DEFAULT '{}'::integer[],
    crontab_line text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tag_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_kinds (
    id bigint NOT NULL,
    name character varying,
    code_name character varying,
    record_type character varying,
    color character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_kinds_id_seq OWNED BY public.tag_kinds.id;


--
-- Name: tag_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_members (
    id bigint NOT NULL,
    record_type character varying,
    record_id bigint,
    tag_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_members_id_seq OWNED BY public.tag_members.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    tag_kind_id bigint,
    rank integer,
    color character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    organization_id bigint,
    job character varying,
    phone character varying,
    mobile_phone character varying,
    description text,
    crypted_password character varying,
    password_salt character varying,
    persistence_token character varying,
    single_access_token character varying,
    perishable_token character varying,
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_request_at timestamp without time zone,
    current_login_at timestamp without time zone,
    last_login_at timestamp without time zone,
    current_login_ip character varying,
    last_login_ip character varying,
    active boolean DEFAULT false,
    approved boolean DEFAULT false,
    confirmed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    department_id bigint,
    rank integer,
    department_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: vulnerabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerabilities (
    id bigint NOT NULL,
    codename character varying,
    feed public.vuln_feed DEFAULT 'custom'::public.vuln_feed,
    vendors text[] DEFAULT '{}'::text[],
    products text[] DEFAULT '{}'::text[],
    cwe text[] DEFAULT '{}'::text[],
    cvss3 numeric(3,1),
    cvss3_vector character varying,
    cvss3_exploitability numeric(3,1),
    cvss3_impact numeric(3,1),
    cvss2 numeric(3,1),
    cvss2_vector character varying,
    cvss2_exploitability numeric(3,1),
    cvss2_impact numeric(3,1),
    description character varying[] DEFAULT '{}'::character varying[],
    published timestamp without time zone,
    published_time boolean DEFAULT false,
    modified timestamp without time zone,
    modified_time boolean DEFAULT false,
    custom_description text,
    custom_recomendation text,
    custom_references text,
    custom_fields jsonb,
    state smallint,
    custom_actuality public.vuln_actuality DEFAULT 'not_set'::public.vuln_actuality,
    actuality public.vuln_actuality DEFAULT 'not_set'::public.vuln_actuality,
    custom_relevance public.vuln_relevance DEFAULT 'not_set'::public.vuln_relevance,
    relevance public.vuln_relevance DEFAULT 'not_set'::public.vuln_relevance,
    blocked boolean DEFAULT false,
    raw_data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vulnerabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerabilities_id_seq OWNED BY public.vulnerabilities.id;


--
-- Name: agreement_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreement_kinds ALTER COLUMN id SET DEFAULT nextval('public.agreement_kinds_id_seq'::regclass);


--
-- Name: agreements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements ALTER COLUMN id SET DEFAULT nextval('public.agreements_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: attachment_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachment_links ALTER COLUMN id SET DEFAULT nextval('public.attachment_links_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: ckeditor_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('public.ckeditor_assets_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields ALTER COLUMN id SET DEFAULT nextval('public.custom_fields_id_seq'::regclass);


--
-- Name: delivery_list_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_list_members ALTER COLUMN id SET DEFAULT nextval('public.delivery_list_members_id_seq'::regclass);


--
-- Name: delivery_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists ALTER COLUMN id SET DEFAULT nextval('public.delivery_lists_id_seq'::regclass);


--
-- Name: delivery_subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects ALTER COLUMN id SET DEFAULT nextval('public.delivery_subjects_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: feeds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds ALTER COLUMN id SET DEFAULT nextval('public.feeds_id_seq'::regclass);


--
-- Name: host_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_services ALTER COLUMN id SET DEFAULT nextval('public.host_services_id_seq'::regclass);


--
-- Name: hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts ALTER COLUMN id SET DEFAULT nextval('public.hosts_id_seq'::regclass);


--
-- Name: incidents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);


--
-- Name: indicator_context_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_context_members ALTER COLUMN id SET DEFAULT nextval('public.indicator_context_members_id_seq'::regclass);


--
-- Name: indicator_contexts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_contexts ALTER COLUMN id SET DEFAULT nextval('public.indicator_contexts_id_seq'::regclass);


--
-- Name: indicators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicators ALTER COLUMN id SET DEFAULT nextval('public.indicators_id_seq'::regclass);


--
-- Name: investigation_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigation_kinds ALTER COLUMN id SET DEFAULT nextval('public.investigation_kinds_id_seq'::regclass);


--
-- Name: investigations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations ALTER COLUMN id SET DEFAULT nextval('public.investigations_id_seq'::regclass);


--
-- Name: link_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link_kinds ALTER COLUMN id SET DEFAULT nextval('public.link_kinds_id_seq'::regclass);


--
-- Name: links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq'::regclass);


--
-- Name: organization_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_kinds ALTER COLUMN id SET DEFAULT nextval('public.organization_kinds_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: record_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_templates ALTER COLUMN id SET DEFAULT nextval('public.record_templates_id_seq'::regclass);


--
-- Name: rights id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rights ALTER COLUMN id SET DEFAULT nextval('public.rights_id_seq'::regclass);


--
-- Name: role_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_members ALTER COLUMN id SET DEFAULT nextval('public.role_members_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: scan_job_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_job_logs ALTER COLUMN id SET DEFAULT nextval('public.scan_job_logs_id_seq'::regclass);


--
-- Name: scan_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs ALTER COLUMN id SET DEFAULT nextval('public.scan_jobs_id_seq'::regclass);


--
-- Name: scan_jobs_hosts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs_hosts ALTER COLUMN id SET DEFAULT nextval('public.scan_jobs_hosts_id_seq'::regclass);


--
-- Name: scan_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_options ALTER COLUMN id SET DEFAULT nextval('public.scan_options_id_seq'::regclass);


--
-- Name: scan_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_results ALTER COLUMN id SET DEFAULT nextval('public.scan_results_id_seq'::regclass);


--
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- Name: tag_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_kinds ALTER COLUMN id SET DEFAULT nextval('public.tag_kinds_id_seq'::regclass);


--
-- Name: tag_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_members ALTER COLUMN id SET DEFAULT nextval('public.tag_members_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: vulnerabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerabilities ALTER COLUMN id SET DEFAULT nextval('public.vulnerabilities_id_seq'::regclass);


--
-- Name: agreement_kinds agreement_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreement_kinds
    ADD CONSTRAINT agreement_kinds_pkey PRIMARY KEY (id);


--
-- Name: agreements agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT agreements_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attachment_links attachment_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachment_links
    ADD CONSTRAINT attachment_links_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: delivery_list_members delivery_list_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_list_members
    ADD CONSTRAINT delivery_list_members_pkey PRIMARY KEY (id);


--
-- Name: delivery_lists delivery_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists
    ADD CONSTRAINT delivery_lists_pkey PRIMARY KEY (id);


--
-- Name: delivery_subjects delivery_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects
    ADD CONSTRAINT delivery_subjects_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: feeds feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: host_services host_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_services
    ADD CONSTRAINT host_services_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: indicator_context_members indicator_context_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_context_members
    ADD CONSTRAINT indicator_context_members_pkey PRIMARY KEY (id);


--
-- Name: indicator_contexts indicator_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_contexts
    ADD CONSTRAINT indicator_contexts_pkey PRIMARY KEY (id);


--
-- Name: indicators indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT indicators_pkey PRIMARY KEY (id);


--
-- Name: investigation_kinds investigation_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigation_kinds
    ADD CONSTRAINT investigation_kinds_pkey PRIMARY KEY (id);


--
-- Name: investigations investigations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations
    ADD CONSTRAINT investigations_pkey PRIMARY KEY (id);


--
-- Name: link_kinds link_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link_kinds
    ADD CONSTRAINT link_kinds_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: organization_kinds organization_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_kinds
    ADD CONSTRAINT organization_kinds_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: record_templates record_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_templates
    ADD CONSTRAINT record_templates_pkey PRIMARY KEY (id);


--
-- Name: rights rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rights
    ADD CONSTRAINT rights_pkey PRIMARY KEY (id);


--
-- Name: role_members role_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_members
    ADD CONSTRAINT role_members_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scan_job_logs scan_job_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_job_logs
    ADD CONSTRAINT scan_job_logs_pkey PRIMARY KEY (id);


--
-- Name: scan_jobs_hosts scan_jobs_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs_hosts
    ADD CONSTRAINT scan_jobs_hosts_pkey PRIMARY KEY (id);


--
-- Name: scan_jobs scan_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs
    ADD CONSTRAINT scan_jobs_pkey PRIMARY KEY (id);


--
-- Name: scan_options scan_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_options
    ADD CONSTRAINT scan_options_pkey PRIMARY KEY (id);


--
-- Name: scan_results scan_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_results
    ADD CONSTRAINT scan_results_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tag_kinds tag_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_kinds
    ADD CONSTRAINT tag_kinds_pkey PRIMARY KEY (id);


--
-- Name: tag_members tag_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_members
    ADD CONSTRAINT tag_members_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: vulnerabilities vulnerabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerabilities
    ADD CONSTRAINT vulnerabilities_pkey PRIMARY KEY (id);


--
-- Name: index_agreement_kinds_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreement_kinds_on_name ON public.agreement_kinds USING btree (name);


--
-- Name: index_agreements_on_agreement_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_agreement_kind_id ON public.agreements USING btree (agreement_kind_id);


--
-- Name: index_agreements_on_beginning; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_beginning ON public.agreements USING btree (beginning);


--
-- Name: index_agreements_on_contractor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_contractor_id ON public.agreements USING btree (contractor_id);


--
-- Name: index_agreements_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_organization_id ON public.agreements USING btree (organization_id);


--
-- Name: index_agreements_on_prop; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_prop ON public.agreements USING btree (prop);


--
-- Name: index_articles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_name ON public.articles USING btree (name);


--
-- Name: index_articles_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_organization_id ON public.articles USING btree (organization_id);


--
-- Name: index_articles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_user_id ON public.articles USING btree (user_id);


--
-- Name: index_attachment_links_on_attachment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachment_links_on_attachment_id ON public.attachment_links USING btree (attachment_id);


--
-- Name: index_attachment_links_on_record_type_and_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachment_links_on_record_type_and_record_id ON public.attachment_links USING btree (record_type, record_id);


--
-- Name: index_attachments_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_name ON public.attachments USING btree (name);


--
-- Name: index_attachments_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_organization_id ON public.attachments USING btree (organization_id);


--
-- Name: index_ckeditor_assets_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ckeditor_assets_on_type ON public.ckeditor_assets USING btree (type);


--
-- Name: index_delivery_list_members_on_delivery_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_list_members_on_delivery_list_id ON public.delivery_list_members USING btree (delivery_list_id);


--
-- Name: index_delivery_list_members_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_list_members_on_organization_id ON public.delivery_list_members USING btree (organization_id);


--
-- Name: index_delivery_lists_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_lists_on_organization_id ON public.delivery_lists USING btree (organization_id);


--
-- Name: index_delivery_subjects_on_deliverable_type_and_deliverable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_deliverable_type_and_deliverable_id ON public.delivery_subjects USING btree (deliverable_type, deliverable_id);


--
-- Name: index_delivery_subjects_on_delivery_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_delivery_list_id ON public.delivery_subjects USING btree (delivery_list_id);


--
-- Name: index_departments_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departments_on_name ON public.departments USING btree (name);


--
-- Name: index_departments_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departments_on_organization_id ON public.departments USING btree (organization_id);


--
-- Name: index_departments_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departments_on_parent_id ON public.departments USING btree (parent_id);


--
-- Name: index_host_services_on_host_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_host_id ON public.host_services USING btree (host_id);


--
-- Name: index_host_services_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_organization_id ON public.host_services USING btree (organization_id);


--
-- Name: index_host_services_on_port; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_port ON public.host_services USING btree (port);


--
-- Name: index_hosts_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_ip ON public.hosts USING btree (ip);


--
-- Name: index_hosts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_organization_id ON public.hosts USING btree (organization_id);


--
-- Name: index_incidents_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incidents_on_organization_id ON public.incidents USING btree (organization_id);


--
-- Name: index_incidents_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incidents_on_user_id ON public.incidents USING btree (user_id);


--
-- Name: index_indicator_context_members_on_indicator_context_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicator_context_members_on_indicator_context_id ON public.indicator_context_members USING btree (indicator_context_id);


--
-- Name: index_indicator_context_members_on_indicator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicator_context_members_on_indicator_id ON public.indicator_context_members USING btree (indicator_id);


--
-- Name: index_indicators_on_content_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_content_gin_trgm_ops ON public.indicators USING gin (content public.gin_trgm_ops);


--
-- Name: index_indicators_on_enrichment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_enrichment ON public.indicators USING gin (enrichment);


--
-- Name: index_indicators_on_investigation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_investigation_id ON public.indicators USING btree (investigation_id);


--
-- Name: index_indicators_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_user_id ON public.indicators USING btree (user_id);


--
-- Name: index_investigations_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_feed_id ON public.investigations USING btree (feed_id);


--
-- Name: index_investigations_on_investigation_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_investigation_kind_id ON public.investigations USING btree (investigation_kind_id);


--
-- Name: index_investigations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_organization_id ON public.investigations USING btree (organization_id);


--
-- Name: index_investigations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_user_id ON public.investigations USING btree (user_id);


--
-- Name: index_links_on_first_record_type_and_first_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_first_record_type_and_first_record_id ON public.links USING btree (first_record_type, first_record_id);


--
-- Name: index_links_on_link_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_link_kind_id ON public.links USING btree (link_kind_id);


--
-- Name: index_links_on_second_record_type_and_second_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_second_record_type_and_second_record_id ON public.links USING btree (second_record_type, second_record_id);


--
-- Name: index_organization_kinds_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_kinds_on_name ON public.organization_kinds USING btree (name);


--
-- Name: index_organizations_on_full_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_full_name ON public.organizations USING btree (full_name);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_name ON public.organizations USING btree (name);


--
-- Name: index_organizations_on_organization_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_organization_kind_id ON public.organizations USING btree (organization_kind_id);


--
-- Name: index_organizations_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_parent_id ON public.organizations USING btree (parent_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_rights_on_inherit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rights_on_inherit ON public.rights USING btree (inherit);


--
-- Name: index_rights_on_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rights_on_level ON public.rights USING btree (level);


--
-- Name: index_rights_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rights_on_organization_id ON public.rights USING btree (organization_id);


--
-- Name: index_rights_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rights_on_role_id ON public.rights USING btree (role_id);


--
-- Name: index_rights_on_subject_type_and_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rights_on_subject_type_and_subject_id ON public.rights USING btree (subject_type, subject_id);


--
-- Name: index_role_members_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_members_on_role_id ON public.role_members USING btree (role_id);


--
-- Name: index_role_members_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_members_on_user_id ON public.role_members USING btree (user_id);


--
-- Name: index_scan_job_logs_on_scan_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_job_logs_on_scan_job_id ON public.scan_job_logs USING btree (scan_job_id);


--
-- Name: index_scan_jobs_hosts_on_host_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_jobs_hosts_on_host_id ON public.scan_jobs_hosts USING btree (host_id);


--
-- Name: index_scan_jobs_hosts_on_scan_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_jobs_hosts_on_scan_job_id ON public.scan_jobs_hosts USING btree (scan_job_id);


--
-- Name: index_scan_jobs_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_jobs_on_organization_id ON public.scan_jobs USING btree (organization_id);


--
-- Name: index_scan_jobs_on_scan_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_jobs_on_scan_option_id ON public.scan_jobs USING btree (scan_option_id);


--
-- Name: index_scan_results_on_jid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_jid ON public.scan_results USING btree (jid);


--
-- Name: index_scan_results_on_port; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_port ON public.scan_results USING btree (port);


--
-- Name: index_scan_results_on_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_product ON public.scan_results USING btree (product);


--
-- Name: index_scan_results_on_scan_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_scan_job_id ON public.scan_results USING btree (scan_job_id);


--
-- Name: index_scan_results_on_service; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_service ON public.scan_results USING btree (service);


--
-- Name: index_scan_results_on_vulners; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_results_on_vulners ON public.scan_results USING gin (vulners);


--
-- Name: index_schedules_on_job_type_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_job_type_and_job_id ON public.schedules USING btree (job_type, job_id);


--
-- Name: index_tag_kinds_on_code_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_kinds_on_code_name ON public.tag_kinds USING btree (code_name);


--
-- Name: index_tag_kinds_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_kinds_on_name ON public.tag_kinds USING btree (name);


--
-- Name: index_tag_members_on_record_type_and_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_members_on_record_type_and_record_id ON public.tag_members USING btree (record_type, record_id);


--
-- Name: index_tag_members_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_members_on_tag_id ON public.tag_members USING btree (tag_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_tags_on_tag_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_tag_kind_id ON public.tags USING btree (tag_kind_id);


--
-- Name: index_users_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_department_id ON public.users USING btree (department_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON public.users USING btree (name);


--
-- Name: index_users_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organization_id ON public.users USING btree (organization_id);


--
-- Name: index_users_on_perishable_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_perishable_token ON public.users USING btree (perishable_token);


--
-- Name: index_users_on_persistence_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_persistence_token ON public.users USING btree (persistence_token);


--
-- Name: index_users_on_single_access_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_single_access_token ON public.users USING btree (single_access_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_vulnerabilities_on_codename; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerabilities_on_codename ON public.vulnerabilities USING btree (codename);


--
-- Name: index_vulnerabilities_on_custom_description_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_description_gin_trgm_ops ON public.vulnerabilities USING gin (custom_description public.gin_trgm_ops);


--
-- Name: index_vulnerabilities_on_cvss2_vector_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_cvss2_vector_gin_trgm_ops ON public.vulnerabilities USING gin (cvss2_vector public.gin_trgm_ops);


--
-- Name: index_vulnerabilities_on_cvss3_vector_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_cvss3_vector_gin_trgm_ops ON public.vulnerabilities USING gin (cvss3_vector public.gin_trgm_ops);


--
-- Name: index_vulnerabilities_on_cwe; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_cwe ON public.vulnerabilities USING gin (cwe);


--
-- Name: index_vulnerabilities_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_description ON public.vulnerabilities USING gin (description);


--
-- Name: index_vulnerabilities_on_modified; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_modified ON public.vulnerabilities USING btree (modified);


--
-- Name: index_vulnerabilities_on_products; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_products ON public.vulnerabilities USING gin (products);


--
-- Name: index_vulnerabilities_on_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_published ON public.vulnerabilities USING btree (published DESC);


--
-- Name: index_vulnerabilities_on_vendors; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_vendors ON public.vulnerabilities USING gin (vendors);


--
-- Name: scan_job_logs fk_rails_013b129140; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_job_logs
    ADD CONSTRAINT fk_rails_013b129140 FOREIGN KEY (scan_job_id) REFERENCES public.scan_jobs(id);


--
-- Name: agreements fk_rails_024a724903; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT fk_rails_024a724903 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: investigations fk_rails_053b3ff7a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations
    ADD CONSTRAINT fk_rails_053b3ff7a7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scan_results fk_rails_05716955e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_results
    ADD CONSTRAINT fk_rails_05716955e9 FOREIGN KEY (scan_job_id) REFERENCES public.scan_jobs(id);


--
-- Name: scan_jobs_hosts fk_rails_0e536c99da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs_hosts
    ADD CONSTRAINT fk_rails_0e536c99da FOREIGN KEY (host_id) REFERENCES public.hosts(id);


--
-- Name: host_services fk_rails_1018d7a07e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_services
    ADD CONSTRAINT fk_rails_1018d7a07e FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: rights fk_rails_14f353f832; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rights
    ADD CONSTRAINT fk_rails_14f353f832 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: delivery_subjects fk_rails_1822f728ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects
    ADD CONSTRAINT fk_rails_1822f728ab FOREIGN KEY (delivery_list_id) REFERENCES public.delivery_lists(id);


--
-- Name: tag_members fk_rails_1e10701e6e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_members
    ADD CONSTRAINT fk_rails_1e10701e6e FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: indicators fk_rails_2313388e41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT fk_rails_2313388e41 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: investigations fk_rails_3a104ea16c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations
    ADD CONSTRAINT fk_rails_3a104ea16c FOREIGN KEY (investigation_kind_id) REFERENCES public.investigation_kinds(id);


--
-- Name: investigations fk_rails_3c29d4c7ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations
    ADD CONSTRAINT fk_rails_3c29d4c7ac FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: articles fk_rails_3d31dad1cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_3d31dad1cc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scan_jobs_hosts fk_rails_46655864e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs_hosts
    ADD CONSTRAINT fk_rails_46655864e6 FOREIGN KEY (scan_job_id) REFERENCES public.scan_jobs(id);


--
-- Name: indicator_context_members fk_rails_4c8cbf51af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_context_members
    ADD CONSTRAINT fk_rails_4c8cbf51af FOREIGN KEY (indicator_context_id) REFERENCES public.indicator_contexts(id);


--
-- Name: agreements fk_rails_55b0ae9928; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT fk_rails_55b0ae9928 FOREIGN KEY (contractor_id) REFERENCES public.organizations(id);


--
-- Name: scan_jobs fk_rails_59050ee868; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs
    ADD CONSTRAINT fk_rails_59050ee868 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: incidents fk_rails_5b1d913b7c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT fk_rails_5b1d913b7c FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: role_members fk_rails_5d78265c8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_members
    ADD CONSTRAINT fk_rails_5d78265c8c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: organizations fk_rails_6551137b98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_6551137b98 FOREIGN KEY (parent_id) REFERENCES public.organizations(id);


--
-- Name: incidents fk_rails_6af30a70d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT fk_rails_6af30a70d3 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: organizations fk_rails_73a117a592; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_73a117a592 FOREIGN KEY (organization_kind_id) REFERENCES public.organization_kinds(id);


--
-- Name: articles fk_rails_7809a1a57d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_7809a1a57d FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: departments fk_rails_8e1e5764fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_rails_8e1e5764fc FOREIGN KEY (parent_id) REFERENCES public.departments(id);


--
-- Name: delivery_list_members fk_rails_90d32e6f96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_list_members
    ADD CONSTRAINT fk_rails_90d32e6f96 FOREIGN KEY (delivery_list_id) REFERENCES public.delivery_lists(id);


--
-- Name: departments fk_rails_94440b0e8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_rails_94440b0e8f FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: delivery_lists fk_rails_971d6bd7da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists
    ADD CONSTRAINT fk_rails_971d6bd7da FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: rights fk_rails_99f9f6987e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rights
    ADD CONSTRAINT fk_rails_99f9f6987e FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: role_members fk_rails_9ec9042bd2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_members
    ADD CONSTRAINT fk_rails_9ec9042bd2 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: indicator_context_members fk_rails_b0bedef6aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_context_members
    ADD CONSTRAINT fk_rails_b0bedef6aa FOREIGN KEY (indicator_id) REFERENCES public.indicators(id);


--
-- Name: agreements fk_rails_b0df4c4847; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT fk_rails_b0df4c4847 FOREIGN KEY (agreement_kind_id) REFERENCES public.agreement_kinds(id);


--
-- Name: attachments fk_rails_b10ecc2b5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT fk_rails_b10ecc2b5d FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: tags fk_rails_b463051f3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_b463051f3b FOREIGN KEY (tag_kind_id) REFERENCES public.tag_kinds(id);


--
-- Name: links fk_rails_bf29091984; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk_rails_bf29091984 FOREIGN KEY (link_kind_id) REFERENCES public.link_kinds(id);


--
-- Name: scan_jobs fk_rails_cc5f382133; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs
    ADD CONSTRAINT fk_rails_cc5f382133 FOREIGN KEY (scan_option_id) REFERENCES public.scan_options(id);


--
-- Name: investigations fk_rails_cca0d30785; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investigations
    ADD CONSTRAINT fk_rails_cca0d30785 FOREIGN KEY (feed_id) REFERENCES public.feeds(id);


--
-- Name: users fk_rails_d7b9ff90af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_d7b9ff90af FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: indicators fk_rails_e08d243821; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT fk_rails_e08d243821 FOREIGN KEY (investigation_id) REFERENCES public.investigations(id);


--
-- Name: hosts fk_rails_e9b8591b46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT fk_rails_e9b8591b46 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: users fk_rails_f29bf9cdf2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_f29bf9cdf2 FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: host_services fk_rails_f3f5e734a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_services
    ADD CONSTRAINT fk_rails_f3f5e734a9 FOREIGN KEY (host_id) REFERENCES public.hosts(id);


--
-- Name: delivery_list_members fk_rails_f5d1bba46a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_list_members
    ADD CONSTRAINT fk_rails_f5d1bba46a FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171009072317'),
('20171010111330'),
('20171011075125'),
('20171013082230'),
('20171022051529'),
('20171028045421'),
('20171028052631'),
('20171028063557'),
('20171106054505'),
('20171112085104'),
('20171122131929'),
('20171122132005'),
('20171122134219'),
('20171125043207'),
('20171125093452'),
('20171203095108'),
('20171203100515'),
('20171210103117'),
('20171210115224'),
('20171212134434'),
('20171221053334'),
('20171221055001'),
('20171221055347'),
('20180129124019'),
('20180222045425'),
('20180222051056'),
('20180227051226'),
('20180306061705'),
('20180309082142'),
('20180309083145'),
('20180314053643'),
('20180329132820'),
('20180407164519'),
('20180407164520'),
('20180415044347'),
('20180415054815'),
('20180509141339'),
('20180509141658'),
('20180519091552'),
('20180526054309'),
('20180607174928'),
('20180714101612'),
('20180714101753'),
('20181026071008'),
('20181028054216'),
('20181030070616'),
('20181031074924'),
('20181031115221'),
('20181102094432'),
('20190217040546'),
('20190301131550'),
('20190302035718'),
('20190302045412'),
('20190302045850'),
('20190511051035'),
('20190511051655'),
('20190518052155'),
('20190529065940'),
('20190601061759'),
('20190601070608'),
('20190602060535');


