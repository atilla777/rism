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
-- Name: custom_report_format; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.custom_report_format AS ENUM (
    'csv',
    'json'
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
    'sha1',
    'sha256',
    'sha512',
    'filename',
    'filesize',
    'process',
    'account',
    'registry'
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
-- Name: net_protocol; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.net_protocol AS ENUM (
    'http',
    'https'
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
-- Name: vuln_exploit_maturity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_exploit_maturity AS ENUM (
    'not_defined',
    'high',
    'functional',
    'poc',
    'unproven'
);


--
-- Name: vuln_feed; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_feed AS ENUM (
    'custom',
    'nvd',
    'bdu'
);


--
-- Name: vuln_relevance; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_relevance AS ENUM (
    'not_set',
    'relevant',
    'not_relevant'
);


--
-- Name: vuln_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vuln_state AS ENUM (
    'modified',
    'published',
    'not_published'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    address cidr,
    hostname character varying,
    protocol public.net_protocol,
    port character varying,
    secret character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agents_id_seq OWNED BY public.agents.id;


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
    prop text,
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
    updated_at timestamp without time zone NOT NULL,
    articles_folder_id bigint,
    published boolean
);


--
-- Name: articles_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles_folders (
    id bigint NOT NULL,
    name character varying,
    rank integer,
    organization_id bigint,
    parent_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_folders_id_seq OWNED BY public.articles_folders.id;


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
-- Name: attached_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attached_files (
    id bigint NOT NULL,
    name character varying,
    new_name character varying,
    filable_type character varying,
    filable_id bigint,
    created_at timestamp without time zone
);


--
-- Name: attached_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attached_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attached_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attached_files_id_seq OWNED BY public.attached_files.id;


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
-- Name: custom_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_reports (
    id bigint NOT NULL,
    folder_id bigint,
    organization_id bigint,
    name character varying,
    description text,
    statement text,
    result_format public.custom_report_format,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    add_csv_header boolean,
    utf_encoding boolean
);


--
-- Name: custom_reports_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_reports_folders (
    id bigint NOT NULL,
    name character varying,
    rank integer,
    description text,
    organization_id bigint,
    parent_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_reports_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_reports_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_reports_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_reports_folders_id_seq OWNED BY public.custom_reports_folders.id;


--
-- Name: custom_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_reports_id_seq OWNED BY public.custom_reports.id;


--
-- Name: custom_reports_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_reports_results (
    id bigint NOT NULL,
    custom_report_id bigint,
    result_path character varying,
    variables jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_reports_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_reports_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_reports_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_reports_results_id_seq OWNED BY public.custom_reports_results.id;


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
-- Name: delivery_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_recipients (
    id bigint NOT NULL,
    delivery_list_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recipientable_type character varying,
    recipientable_id bigint
);


--
-- Name: delivery_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delivery_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delivery_recipients_id_seq OWNED BY public.delivery_recipients.id;


--
-- Name: delivery_subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_subjects (
    id bigint NOT NULL,
    deliverable_type character varying,
    deliverable_id bigint,
    delivery_list_id bigint,
    answerable boolean DEFAULT false,
    sent_at timestamp without time zone,
    created_by_id bigint,
    updated_by_id bigint,
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
-- Name: enrichments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enrichments (
    id bigint NOT NULL,
    content jsonb DEFAULT '{}'::jsonb NOT NULL,
    enrichmentable_type character varying,
    enrichmentable_id bigint,
    broker smallint,
    created_at timestamp without time zone
);


--
-- Name: enrichments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.enrichments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enrichments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.enrichments_id_seq OWNED BY public.enrichments.id;


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
-- Name: host_service_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.host_service_statuses (
    id bigint NOT NULL,
    name character varying,
    rank smallint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: host_service_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.host_service_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: host_service_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.host_service_statuses_id_seq OWNED BY public.host_service_statuses.id;


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
    vuln_description text,
    host_service_status_id bigint,
    host_service_status_changed_at timestamp without time zone,
    host_service_status_prop character varying
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
    updated_at timestamp without time zone NOT NULL,
    created_by_id bigint,
    updated_by_id bigint
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
    investigation_id bigint,
    parent_id bigint,
    parent_conjunction boolean,
    trust_level public.indicator_trust_level DEFAULT 'not_set'::public.indicator_trust_level,
    content character varying,
    content_format public.indicator_content_format,
    purpose public.indicator_purpose DEFAULT 'not_set'::public.indicator_purpose,
    description text,
    custom_fields jsonb,
    created_by_id bigint,
    updated_by_id bigint,
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
    custom_codename character varying,
    organization_id bigint,
    investigation_kind_id bigint,
    feed_id bigint,
    custom_fields jsonb,
    description text,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feed_codename character varying
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
-- Name: notifications_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications_logs (
    id bigint NOT NULL,
    user_id bigint,
    deliverable_type character varying,
    deliverable_id bigint,
    recipient_id bigint,
    created_at timestamp without time zone
);


--
-- Name: notifications_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_logs_id_seq OWNED BY public.notifications_logs.id;


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
    organization_kind_id bigint,
    codename character varying
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
-- Name: processing_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.processing_logs (
    id bigint NOT NULL,
    processed boolean,
    processable_type character varying,
    processable_id bigint,
    organization_id bigint,
    processed_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: processing_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.processing_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: processing_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.processing_logs_id_seq OWNED BY public.processing_logs.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publications (
    id bigint NOT NULL,
    publicable_type character varying,
    publicable_id bigint,
    created_at timestamp without time zone
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publications_id_seq OWNED BY public.publications.id;


--
-- Name: readable_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.readable_logs (
    id bigint NOT NULL,
    user_id bigint,
    readable_type character varying,
    readable_id bigint,
    read_created_at timestamp without time zone,
    read_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: readable_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.readable_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: readable_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.readable_logs_id_seq OWNED BY public.readable_logs.id;


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
    updated_at timestamp without time zone NOT NULL,
    user_id bigint,
    organization_id bigint
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
    updated_at timestamp without time zone NOT NULL,
    agent_id bigint
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
-- Name: search_filters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search_filters (
    id bigint NOT NULL,
    name character varying,
    filtred_model character varying,
    organization_id bigint,
    user_id bigint,
    shared boolean,
    rank integer,
    content jsonb,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: search_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.search_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.search_filters_id_seq OWNED BY public.search_filters.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    user_id bigint,
    publicable_type character varying,
    created_at timestamp without time zone
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: tag_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_kinds (
    id bigint NOT NULL,
    name character varying,
    code_name character varying,
    record_type character varying,
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
-- Name: user_actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_actions (
    id bigint NOT NULL,
    user_id bigint,
    controller character varying,
    action character varying,
    params jsonb,
    ip cidr,
    browser character varying,
    event smallint,
    record_model character varying,
    record_id integer,
    comment text,
    created_at timestamp without time zone
);


--
-- Name: user_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_actions_id_seq OWNED BY public.user_actions.id;


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
    department_name character varying,
    api_token character varying,
    api_user boolean
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
    custom_vendors text[] DEFAULT '{}'::text[],
    custom_products text[] DEFAULT '{}'::text[],
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
    custom_fields jsonb,
    custom_cvss3 numeric(3,1),
    custom_cvss3_vector character varying,
    custom_cvss3_exploitability numeric(3,1),
    custom_cvss3_impact numeric(3,1),
    custom_description text,
    custom_recomendation text,
    custom_references text,
    state public.vuln_state,
    processed boolean DEFAULT false,
    processed_by_id bigint,
    custom_actuality public.vuln_actuality DEFAULT 'not_set'::public.vuln_actuality,
    actuality public.vuln_actuality DEFAULT 'not_set'::public.vuln_actuality,
    custom_relevance public.vuln_relevance DEFAULT 'not_set'::public.vuln_relevance,
    relevance public.vuln_relevance DEFAULT 'not_set'::public.vuln_relevance,
    blocked boolean DEFAULT false,
    raw_data jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    exploit boolean,
    custom_exploit boolean,
    exploit_maturity public.vuln_exploit_maturity DEFAULT 'not_defined'::public.vuln_exploit_maturity,
    custom_exploit_maturity public.vuln_exploit_maturity DEFAULT 'not_defined'::public.vuln_exploit_maturity,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vulnerability_kind_id bigint,
    custom_published timestamp without time zone,
    custom_published_time boolean DEFAULT false,
    custom_codenames text[] DEFAULT '{}'::text[],
    changed_fields text[] DEFAULT '{}'::text[],
    processed_at timestamp without time zone
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
-- Name: vulnerability_bulletin_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_bulletin_kinds (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id bigint
);


--
-- Name: vulnerability_bulletin_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_bulletin_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_bulletin_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_bulletin_kinds_id_seq OWNED BY public.vulnerability_bulletin_kinds.id;


--
-- Name: vulnerability_bulletin_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_bulletin_members (
    id bigint NOT NULL,
    vulnerability_id bigint,
    vulnerability_bulletin_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vulnerability_bulletin_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_bulletin_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_bulletin_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_bulletin_members_id_seq OWNED BY public.vulnerability_bulletin_members.id;


--
-- Name: vulnerability_bulletin_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_bulletin_statuses (
    id bigint NOT NULL,
    name character varying,
    organization_id bigint,
    description text,
    rank smallint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vulnerability_bulletin_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_bulletin_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_bulletin_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_bulletin_statuses_id_seq OWNED BY public.vulnerability_bulletin_statuses.id;


--
-- Name: vulnerability_bulletins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_bulletins (
    id bigint NOT NULL,
    name character varying,
    codename character varying,
    organization_id bigint,
    vulnerability_bulletin_kind_id bigint,
    custom_fields jsonb,
    description text,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vulnerability_bulletin_status_id bigint
);


--
-- Name: vulnerability_bulletins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_bulletins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_bulletins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_bulletins_id_seq OWNED BY public.vulnerability_bulletins.id;


--
-- Name: vulnerability_kinds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_kinds (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vulnerability_kinds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_kinds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_kinds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_kinds_id_seq OWNED BY public.vulnerability_kinds.id;


--
-- Name: agents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents ALTER COLUMN id SET DEFAULT nextval('public.agents_id_seq'::regclass);


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
-- Name: articles_folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_folders ALTER COLUMN id SET DEFAULT nextval('public.articles_folders_id_seq'::regclass);


--
-- Name: attached_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attached_files ALTER COLUMN id SET DEFAULT nextval('public.attached_files_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields ALTER COLUMN id SET DEFAULT nextval('public.custom_fields_id_seq'::regclass);


--
-- Name: custom_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports ALTER COLUMN id SET DEFAULT nextval('public.custom_reports_id_seq'::regclass);


--
-- Name: custom_reports_folders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_folders ALTER COLUMN id SET DEFAULT nextval('public.custom_reports_folders_id_seq'::regclass);


--
-- Name: custom_reports_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_results ALTER COLUMN id SET DEFAULT nextval('public.custom_reports_results_id_seq'::regclass);


--
-- Name: delivery_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists ALTER COLUMN id SET DEFAULT nextval('public.delivery_lists_id_seq'::regclass);


--
-- Name: delivery_recipients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_recipients ALTER COLUMN id SET DEFAULT nextval('public.delivery_recipients_id_seq'::regclass);


--
-- Name: delivery_subjects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects ALTER COLUMN id SET DEFAULT nextval('public.delivery_subjects_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: enrichments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enrichments ALTER COLUMN id SET DEFAULT nextval('public.enrichments_id_seq'::regclass);


--
-- Name: feeds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds ALTER COLUMN id SET DEFAULT nextval('public.feeds_id_seq'::regclass);


--
-- Name: host_service_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_service_statuses ALTER COLUMN id SET DEFAULT nextval('public.host_service_statuses_id_seq'::regclass);


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
-- Name: notifications_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications_logs ALTER COLUMN id SET DEFAULT nextval('public.notifications_logs_id_seq'::regclass);


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
-- Name: processing_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_logs ALTER COLUMN id SET DEFAULT nextval('public.processing_logs_id_seq'::regclass);


--
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications ALTER COLUMN id SET DEFAULT nextval('public.publications_id_seq'::regclass);


--
-- Name: readable_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readable_logs ALTER COLUMN id SET DEFAULT nextval('public.readable_logs_id_seq'::regclass);


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
-- Name: search_filters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_filters ALTER COLUMN id SET DEFAULT nextval('public.search_filters_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


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
-- Name: user_actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_actions ALTER COLUMN id SET DEFAULT nextval('public.user_actions_id_seq'::regclass);


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
-- Name: vulnerability_bulletin_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_kinds ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_bulletin_kinds_id_seq'::regclass);


--
-- Name: vulnerability_bulletin_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_members ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_bulletin_members_id_seq'::regclass);


--
-- Name: vulnerability_bulletin_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_statuses ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_bulletin_statuses_id_seq'::regclass);


--
-- Name: vulnerability_bulletins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletins ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_bulletins_id_seq'::regclass);


--
-- Name: vulnerability_kinds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_kinds ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_kinds_id_seq'::regclass);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


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
-- Name: articles_folders articles_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_folders
    ADD CONSTRAINT articles_folders_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attached_files attached_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attached_files
    ADD CONSTRAINT attached_files_pkey PRIMARY KEY (id);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: custom_reports_folders custom_reports_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_folders
    ADD CONSTRAINT custom_reports_folders_pkey PRIMARY KEY (id);


--
-- Name: custom_reports custom_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports
    ADD CONSTRAINT custom_reports_pkey PRIMARY KEY (id);


--
-- Name: custom_reports_results custom_reports_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_results
    ADD CONSTRAINT custom_reports_results_pkey PRIMARY KEY (id);


--
-- Name: delivery_lists delivery_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_lists
    ADD CONSTRAINT delivery_lists_pkey PRIMARY KEY (id);


--
-- Name: delivery_recipients delivery_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_recipients
    ADD CONSTRAINT delivery_recipients_pkey PRIMARY KEY (id);


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
-- Name: enrichments enrichments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enrichments
    ADD CONSTRAINT enrichments_pkey PRIMARY KEY (id);


--
-- Name: feeds feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: host_service_statuses host_service_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_service_statuses
    ADD CONSTRAINT host_service_statuses_pkey PRIMARY KEY (id);


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
-- Name: notifications_logs notifications_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications_logs
    ADD CONSTRAINT notifications_logs_pkey PRIMARY KEY (id);


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
-- Name: processing_logs processing_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_logs
    ADD CONSTRAINT processing_logs_pkey PRIMARY KEY (id);


--
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: readable_logs readable_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readable_logs
    ADD CONSTRAINT readable_logs_pkey PRIMARY KEY (id);


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
-- Name: search_filters search_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_filters
    ADD CONSTRAINT search_filters_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


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
-- Name: user_actions user_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_actions
    ADD CONSTRAINT user_actions_pkey PRIMARY KEY (id);


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
-- Name: vulnerability_bulletin_kinds vulnerability_bulletin_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_kinds
    ADD CONSTRAINT vulnerability_bulletin_kinds_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_bulletin_members vulnerability_bulletin_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_members
    ADD CONSTRAINT vulnerability_bulletin_members_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_bulletin_statuses vulnerability_bulletin_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_statuses
    ADD CONSTRAINT vulnerability_bulletin_statuses_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_bulletins vulnerability_bulletins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletins
    ADD CONSTRAINT vulnerability_bulletins_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_kinds vulnerability_kinds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_kinds
    ADD CONSTRAINT vulnerability_kinds_pkey PRIMARY KEY (id);


--
-- Name: index_agents_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agents_on_organization_id ON public.agents USING btree (organization_id);


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
-- Name: index_articles_folders_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_folders_on_name ON public.articles_folders USING btree (name);


--
-- Name: index_articles_folders_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_folders_on_organization_id ON public.articles_folders USING btree (organization_id);


--
-- Name: index_articles_folders_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_folders_on_parent_id ON public.articles_folders USING btree (parent_id);


--
-- Name: index_articles_on_articles_folder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_articles_folder_id ON public.articles USING btree (articles_folder_id);


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
-- Name: index_attached_files_on_filable_type_and_filable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attached_files_on_filable_type_and_filable_id ON public.attached_files USING btree (filable_type, filable_id);


--
-- Name: index_custom_reports_folders_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_folders_on_name ON public.custom_reports_folders USING btree (name);


--
-- Name: index_custom_reports_folders_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_folders_on_organization_id ON public.custom_reports_folders USING btree (organization_id);


--
-- Name: index_custom_reports_folders_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_folders_on_parent_id ON public.custom_reports_folders USING btree (parent_id);


--
-- Name: index_custom_reports_on_folder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_on_folder_id ON public.custom_reports USING btree (folder_id);


--
-- Name: index_custom_reports_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_on_name ON public.custom_reports USING btree (name);


--
-- Name: index_custom_reports_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_on_organization_id ON public.custom_reports USING btree (organization_id);


--
-- Name: index_custom_reports_results_on_custom_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_reports_results_on_custom_report_id ON public.custom_reports_results USING btree (custom_report_id);


--
-- Name: index_delivery_lists_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_lists_on_organization_id ON public.delivery_lists USING btree (organization_id);


--
-- Name: index_delivery_recipients_on_delivery_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_recipients_on_delivery_list_id ON public.delivery_recipients USING btree (delivery_list_id);


--
-- Name: index_delivery_subjects_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_created_by_id ON public.delivery_subjects USING btree (created_by_id);


--
-- Name: index_delivery_subjects_on_deliverable_type_and_deliverable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_deliverable_type_and_deliverable_id ON public.delivery_subjects USING btree (deliverable_type, deliverable_id);


--
-- Name: index_delivery_subjects_on_delivery_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_delivery_list_id ON public.delivery_subjects USING btree (delivery_list_id);


--
-- Name: index_delivery_subjects_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_subjects_on_updated_by_id ON public.delivery_subjects USING btree (updated_by_id);


--
-- Name: index_delvery_recipients_on_r_type_and_r_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delvery_recipients_on_r_type_and_r_id ON public.delivery_recipients USING btree (recipientable_type, recipientable_id);


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
-- Name: index_enrichments_on_enrichmentable_type_and_enrichmentable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_enrichments_on_enrichmentable_type_and_enrichmentable_id ON public.enrichments USING btree (enrichmentable_type, enrichmentable_id);


--
-- Name: index_host_services_on_host_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_host_id ON public.host_services USING btree (host_id);


--
-- Name: index_host_services_on_host_service_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_host_service_status_id ON public.host_services USING btree (host_service_status_id);


--
-- Name: index_host_services_on_host_service_status_prop; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_host_service_status_prop ON public.host_services USING btree (host_service_status_prop);


--
-- Name: index_host_services_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_organization_id ON public.host_services USING btree (organization_id);


--
-- Name: index_host_services_on_port; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_services_on_port ON public.host_services USING btree (port);


--
-- Name: index_hosts_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_created_by_id ON public.hosts USING btree (created_by_id);


--
-- Name: index_hosts_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosts_on_ip ON public.hosts USING btree (ip);


--
-- Name: index_hosts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_organization_id ON public.hosts USING btree (organization_id);


--
-- Name: index_hosts_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosts_on_updated_by_id ON public.hosts USING btree (updated_by_id);


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
-- Name: index_indicators_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_created_by_id ON public.indicators USING btree (created_by_id);


--
-- Name: index_indicators_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_custom_fields ON public.indicators USING gin (custom_fields);


--
-- Name: index_indicators_on_investigation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_investigation_id ON public.indicators USING btree (investigation_id);


--
-- Name: index_indicators_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_parent_id ON public.indicators USING btree (parent_id);


--
-- Name: index_indicators_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_indicators_on_updated_by_id ON public.indicators USING btree (updated_by_id);


--
-- Name: index_investigations_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_created_by_id ON public.investigations USING btree (created_by_id);


--
-- Name: index_investigations_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_custom_fields ON public.investigations USING gin (custom_fields);


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
-- Name: index_investigations_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investigations_on_updated_by_id ON public.investigations USING btree (updated_by_id);


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
-- Name: index_notifications_logs_on_deliverable_type_and_deliverable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_logs_on_deliverable_type_and_deliverable_id ON public.notifications_logs USING btree (deliverable_type, deliverable_id);


--
-- Name: index_notifications_logs_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_logs_on_recipient_id ON public.notifications_logs USING btree (recipient_id);


--
-- Name: index_notifications_logs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_logs_on_user_id ON public.notifications_logs USING btree (user_id);


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

CREATE UNIQUE INDEX index_organizations_on_name ON public.organizations USING btree (name);


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
-- Name: index_processing_logs_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_processing_logs_on_organization_id ON public.processing_logs USING btree (organization_id);


--
-- Name: index_processing_logs_on_processable_type_and_processable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_processing_logs_on_processable_type_and_processable_id ON public.processing_logs USING btree (processable_type, processable_id);


--
-- Name: index_processing_logs_on_processed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_processing_logs_on_processed_by_id ON public.processing_logs USING btree (processed_by_id);


--
-- Name: index_publications_on_publicable_type_and_publicable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_publications_on_publicable_type_and_publicable_id ON public.publications USING btree (publicable_type, publicable_id);


--
-- Name: index_readable_logs_on_readable_type_and_readable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_readable_logs_on_readable_type_and_readable_id ON public.readable_logs USING btree (readable_type, readable_id);


--
-- Name: index_readable_logs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_readable_logs_on_user_id ON public.readable_logs USING btree (user_id);


--
-- Name: index_record_templates_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_record_templates_on_organization_id ON public.record_templates USING btree (organization_id);


--
-- Name: index_record_templates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_record_templates_on_user_id ON public.record_templates USING btree (user_id);


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
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_name ON public.roles USING btree (name);


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
-- Name: index_scan_jobs_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scan_jobs_on_agent_id ON public.scan_jobs USING btree (agent_id);


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
-- Name: index_search_filters_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_filters_on_organization_id ON public.search_filters USING btree (organization_id);


--
-- Name: index_search_filters_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_search_filters_on_user_id ON public.search_filters USING btree (user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON public.subscriptions USING btree (user_id);


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
-- Name: index_user_actions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_actions_on_user_id ON public.user_actions USING btree (user_id);


--
-- Name: index_users_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_api_token ON public.users USING btree (api_token);


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
-- Name: index_vul_bul_on_vul_bul_stat_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vul_bul_on_vul_bul_stat_id ON public.vulnerability_bulletins USING btree (vulnerability_bulletin_status_id);


--
-- Name: index_vulnerabilities_on_changed_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_changed_fields ON public.vulnerabilities USING gin (changed_fields);


--
-- Name: index_vulnerabilities_on_codename; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerabilities_on_codename ON public.vulnerabilities USING btree (codename);


--
-- Name: index_vulnerabilities_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_created_by_id ON public.vulnerabilities USING btree (created_by_id);


--
-- Name: index_vulnerabilities_on_custom_codenames; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_codenames ON public.vulnerabilities USING gin (custom_codenames);


--
-- Name: index_vulnerabilities_on_custom_description_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_description_gin_trgm_ops ON public.vulnerabilities USING gin (custom_description public.gin_trgm_ops);


--
-- Name: index_vulnerabilities_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_fields ON public.vulnerabilities USING gin (custom_fields);


--
-- Name: index_vulnerabilities_on_custom_products; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_products ON public.vulnerabilities USING gin (custom_products);


--
-- Name: index_vulnerabilities_on_custom_vendors; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_custom_vendors ON public.vulnerabilities USING gin (custom_vendors);


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
-- Name: index_vulnerabilities_on_processed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_processed_by_id ON public.vulnerabilities USING btree (processed_by_id);


--
-- Name: index_vulnerabilities_on_products; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_products ON public.vulnerabilities USING gin (products);


--
-- Name: index_vulnerabilities_on_published; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_published ON public.vulnerabilities USING btree (published DESC);


--
-- Name: index_vulnerabilities_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_updated_by_id ON public.vulnerabilities USING btree (updated_by_id);


--
-- Name: index_vulnerabilities_on_vendors; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_vendors ON public.vulnerabilities USING gin (vendors);


--
-- Name: index_vulnerabilities_on_vulnerability_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerabilities_on_vulnerability_kind_id ON public.vulnerabilities USING btree (vulnerability_kind_id);


--
-- Name: index_vulnerability_bulletin_kinds_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletin_kinds_on_organization_id ON public.vulnerability_bulletin_kinds USING btree (organization_id);


--
-- Name: index_vulnerability_bulletin_members_on_vulnerability_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletin_members_on_vulnerability_id ON public.vulnerability_bulletin_members USING btree (vulnerability_id);


--
-- Name: index_vulnerability_bulletin_statuses_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletin_statuses_on_organization_id ON public.vulnerability_bulletin_statuses USING btree (organization_id);


--
-- Name: index_vulnerability_bulletins_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletins_on_created_by_id ON public.vulnerability_bulletins USING btree (created_by_id);


--
-- Name: index_vulnerability_bulletins_on_custom_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletins_on_custom_fields ON public.vulnerability_bulletins USING gin (custom_fields);


--
-- Name: index_vulnerability_bulletins_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletins_on_organization_id ON public.vulnerability_bulletins USING btree (organization_id);


--
-- Name: index_vulnerability_bulletins_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletins_on_updated_by_id ON public.vulnerability_bulletins USING btree (updated_by_id);


--
-- Name: index_vulnerability_bulletins_on_vulnerability_bulletin_kind_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_bulletins_on_vulnerability_bulletin_kind_id ON public.vulnerability_bulletins USING btree (vulnerability_bulletin_kind_id);


--
-- Name: index_vulny_bulletin_members_on_vuln_bulletin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulny_bulletin_members_on_vuln_bulletin_id ON public.vulnerability_bulletin_members USING btree (vulnerability_bulletin_id);


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
-- Name: user_actions fk_rails_03991e1c48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_actions
    ADD CONSTRAINT fk_rails_03991e1c48 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scan_results fk_rails_05716955e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_results
    ADD CONSTRAINT fk_rails_05716955e9 FOREIGN KEY (scan_job_id) REFERENCES public.scan_jobs(id);


--
-- Name: vulnerability_bulletin_kinds fk_rails_07379ab2f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_kinds
    ADD CONSTRAINT fk_rails_07379ab2f8 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: vulnerability_bulletins fk_rails_09f3770dbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletins
    ADD CONSTRAINT fk_rails_09f3770dbd FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


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
-- Name: vulnerability_bulletins fk_rails_1e92c2770d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletins
    ADD CONSTRAINT fk_rails_1e92c2770d FOREIGN KEY (vulnerability_bulletin_status_id) REFERENCES public.vulnerability_bulletin_statuses(id);


--
-- Name: readable_logs fk_rails_3732af80d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readable_logs
    ADD CONSTRAINT fk_rails_3732af80d4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: articles_folders fk_rails_3792e20256; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_folders
    ADD CONSTRAINT fk_rails_3792e20256 FOREIGN KEY (parent_id) REFERENCES public.articles_folders(id);


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
-- Name: vulnerability_bulletin_members fk_rails_4289ee7b94; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_members
    ADD CONSTRAINT fk_rails_4289ee7b94 FOREIGN KEY (vulnerability_id) REFERENCES public.vulnerabilities(id);


--
-- Name: scan_jobs_hosts fk_rails_46655864e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs_hosts
    ADD CONSTRAINT fk_rails_46655864e6 FOREIGN KEY (scan_job_id) REFERENCES public.scan_jobs(id);


--
-- Name: vulnerability_bulletin_members fk_rails_4881f2259a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_members
    ADD CONSTRAINT fk_rails_4881f2259a FOREIGN KEY (vulnerability_bulletin_id) REFERENCES public.vulnerability_bulletins(id);


--
-- Name: indicator_context_members fk_rails_4c8cbf51af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicator_context_members
    ADD CONSTRAINT fk_rails_4c8cbf51af FOREIGN KEY (indicator_context_id) REFERENCES public.indicator_contexts(id);


--
-- Name: processing_logs fk_rails_5446e99f57; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_logs
    ADD CONSTRAINT fk_rails_5446e99f57 FOREIGN KEY (processed_by_id) REFERENCES public.users(id);


--
-- Name: agreements fk_rails_55b0ae9928; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT fk_rails_55b0ae9928 FOREIGN KEY (contractor_id) REFERENCES public.organizations(id);


--
-- Name: search_filters fk_rails_56c4284722; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_filters
    ADD CONSTRAINT fk_rails_56c4284722 FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- Name: vulnerabilities fk_rails_5f089792db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerabilities
    ADD CONSTRAINT fk_rails_5f089792db FOREIGN KEY (vulnerability_kind_id) REFERENCES public.vulnerability_kinds(id);


--
-- Name: custom_reports_results fk_rails_627b1b4845; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_results
    ADD CONSTRAINT fk_rails_627b1b4845 FOREIGN KEY (custom_report_id) REFERENCES public.custom_reports(id);


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
-- Name: record_templates fk_rails_6ce138b44d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_templates
    ADD CONSTRAINT fk_rails_6ce138b44d FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: delivery_subjects fk_rails_6e21ed2cf6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects
    ADD CONSTRAINT fk_rails_6e21ed2cf6 FOREIGN KEY (updated_by_id) REFERENCES public.users(id);


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
-- Name: delivery_recipients fk_rails_833f5f3e8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_recipients
    ADD CONSTRAINT fk_rails_833f5f3e8e FOREIGN KEY (delivery_list_id) REFERENCES public.delivery_lists(id);


--
-- Name: scan_jobs fk_rails_8409e65387; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scan_jobs
    ADD CONSTRAINT fk_rails_8409e65387 FOREIGN KEY (agent_id) REFERENCES public.agents(id);


--
-- Name: notifications_logs fk_rails_86ff37d580; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications_logs
    ADD CONSTRAINT fk_rails_86ff37d580 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: custom_reports_folders fk_rails_8abf06e30f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_folders
    ADD CONSTRAINT fk_rails_8abf06e30f FOREIGN KEY (parent_id) REFERENCES public.custom_reports_folders(id);


--
-- Name: search_filters fk_rails_8b18112236; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_filters
    ADD CONSTRAINT fk_rails_8b18112236 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: departments fk_rails_8e1e5764fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_rails_8e1e5764fc FOREIGN KEY (parent_id) REFERENCES public.departments(id);


--
-- Name: subscriptions fk_rails_933bdff476; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_933bdff476 FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- Name: vulnerability_bulletins fk_rails_a5bf6b1a42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletins
    ADD CONSTRAINT fk_rails_a5bf6b1a42 FOREIGN KEY (vulnerability_bulletin_kind_id) REFERENCES public.vulnerability_bulletin_kinds(id);


--
-- Name: host_services fk_rails_ad13b6d403; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_services
    ADD CONSTRAINT fk_rails_ad13b6d403 FOREIGN KEY (host_service_status_id) REFERENCES public.host_service_statuses(id);


--
-- Name: agents fk_rails_b081040964; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT fk_rails_b081040964 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


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
-- Name: tags fk_rails_b463051f3b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_b463051f3b FOREIGN KEY (tag_kind_id) REFERENCES public.tag_kinds(id);


--
-- Name: custom_reports fk_rails_b616f2a992; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports
    ADD CONSTRAINT fk_rails_b616f2a992 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: links fk_rails_bf29091984; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT fk_rails_bf29091984 FOREIGN KEY (link_kind_id) REFERENCES public.link_kinds(id);


--
-- Name: vulnerability_bulletin_statuses fk_rails_c6ede578f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_bulletin_statuses
    ADD CONSTRAINT fk_rails_c6ede578f1 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: vulnerabilities fk_rails_caf83a8f98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerabilities
    ADD CONSTRAINT fk_rails_caf83a8f98 FOREIGN KEY (processed_by_id) REFERENCES public.users(id);


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
-- Name: articles_folders fk_rails_d15051faea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_folders
    ADD CONSTRAINT fk_rails_d15051faea FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: users fk_rails_d7b9ff90af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_d7b9ff90af FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: custom_reports fk_rails_dfeb7aa246; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports
    ADD CONSTRAINT fk_rails_dfeb7aa246 FOREIGN KEY (folder_id) REFERENCES public.custom_reports_folders(id);


--
-- Name: indicators fk_rails_e08d243821; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT fk_rails_e08d243821 FOREIGN KEY (investigation_id) REFERENCES public.investigations(id);


--
-- Name: delivery_subjects fk_rails_e2dadcfc6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_subjects
    ADD CONSTRAINT fk_rails_e2dadcfc6d FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: record_templates fk_rails_e64d64f003; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record_templates
    ADD CONSTRAINT fk_rails_e64d64f003 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: articles fk_rails_e8e3fd2578; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_e8e3fd2578 FOREIGN KEY (articles_folder_id) REFERENCES public.articles_folders(id);


--
-- Name: hosts fk_rails_e9b8591b46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT fk_rails_e9b8591b46 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: processing_logs fk_rails_ecede7c3fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_logs
    ADD CONSTRAINT fk_rails_ecede7c3fc FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: custom_reports_folders fk_rails_f25f909f84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_reports_folders
    ADD CONSTRAINT fk_rails_f25f909f84 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


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
('20190602060535'),
('20190625133152'),
('20190704143524'),
('20190704145457'),
('20190807140005'),
('20190808090026'),
('20190810041847'),
('20190810045108'),
('20190810071507'),
('20190811033116'),
('20190814124932'),
('20190814130942'),
('20190819144024'),
('20190828092009'),
('20190828113245'),
('20190829121711'),
('20190831035612'),
('20190831044448'),
('20190901043622'),
('20190904135959'),
('20190912112513'),
('20191106112505'),
('20191118062554'),
('20191125065845'),
('20191126092016'),
('20191205081705'),
('20191211090648'),
('20191223073226'),
('20200122093326'),
('20200122101959'),
('20200129062359'),
('20200216024320'),
('20200216024627'),
('20200227114354'),
('20200227133341'),
('20200301031546'),
('20200331073332'),
('20200402065224'),
('20200506123638'),
('20200514091343'),
('20200514135141'),
('20200519095614'),
('20200520063353'),
('20200520100915'),
('20200522063839'),
('20200522064856'),
('20200526072228'),
('20200528111802'),
('20200528132834'),
('20200921061604'),
('20200921101622');


