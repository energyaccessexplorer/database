--
-- Name: geographies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geographies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(64),
    adm integer,
    circle public.epiphet DEFAULT 'public'::name,
    envelope double precision[] DEFAULT ARRAY[]::double precision[],
    resolution integer DEFAULT 1000,
    parent_id uuid,
    configuration jsonb DEFAULT jsonb_build_object('boundaries_name', NULL::unknown, 'timeline', false, 'timeline_dates', NULL::unknown, 'flag', NULL::unknown, 'sort_branches', ARRAY[]::text[], 'sort_subbranches', ARRAY[]::text[], 'sort_datasets', ARRAY[]::text[]),
    deployment public.environments[] DEFAULT ARRAY[]::public.environments[],
    flagged boolean DEFAULT false,
    created date DEFAULT CURRENT_DATE,
    created_by character varying(64),
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(64),
    area bigint,
    CONSTRAINT geographies_envelope_check CHECK (((envelope[1] >= ('-180'::integer)::double precision) AND (envelope[3] <= (180)::double precision) AND (envelope[1] < envelope[3]) AND (envelope[2] >= ('-90'::integer)::double precision) AND (envelope[4] <= (90)::double precision) AND (envelope[2] < envelope[4])))
);
