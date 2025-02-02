--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid NOT NULL,
    geography_id uuid NOT NULL,
    name public.epiphet DEFAULT NULL::name,
    name_long text,
    deployment public.environments[] DEFAULT ARRAY[]::public.environments[],
    flagged boolean DEFAULT false,
    configuration jsonb DEFAULT 'null'::jsonb,
    category_overrides jsonb DEFAULT 'null'::jsonb,
    source_files jsonb DEFAULT '[]'::jsonb,
    processed_files jsonb DEFAULT '[]'::jsonb,
    metadata jsonb DEFAULT jsonb_build_object('description', NULL::unknown, 'suggested_citation', NULL::unknown, 'cautions', NULL::unknown, 'spatial_resolution', NULL::unknown, 'license', NULL::unknown, 'sources', NULL::unknown, 'content_date', NULL::unknown, 'download_original_url', NULL::unknown, 'learn_more_url', NULL::unknown),
    created date DEFAULT CURRENT_DATE,
    created_by character varying(64),
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(64),
    notification_interval text,
    notification_latest date,
    CONSTRAINT datasets_notification_interval_check CHECK ((notification_interval ~ '^[0-9]{1,2} (day|week|month|year)s?$'::text))
);
