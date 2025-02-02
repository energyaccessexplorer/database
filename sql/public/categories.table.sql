--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.epiphet NOT NULL,
    name_long character varying(64) NOT NULL,
    unit character varying(32),
    domain jsonb DEFAULT 'null'::jsonb,
    domain_init jsonb DEFAULT 'null'::jsonb,
    colorstops jsonb DEFAULT 'null'::jsonb,
    raster jsonb DEFAULT 'null'::jsonb,
    vectors jsonb DEFAULT 'null'::jsonb,
    csv jsonb DEFAULT 'null'::jsonb,
    analysis jsonb DEFAULT 'null'::jsonb,
    timeline jsonb DEFAULT 'null'::jsonb,
    mutant boolean DEFAULT false,
    controls jsonb DEFAULT jsonb_build_object('range', NULL::unknown, 'range_steps', NULL::unknown, 'range_label', NULL::unknown, 'path', ARRAY[]::text[], 'weight', false),
    description text,
    created date DEFAULT CURRENT_DATE,
    created_by character varying(64),
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(64),
    circle public.epiphet DEFAULT 'everywhere'::name,
    deployment public.environments[] DEFAULT ARRAY[]::public.environments[]
);
