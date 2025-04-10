--
-- Name: datasets_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets_permissions (
    user_id uuid NOT NULL,
    type public.permission_types NOT NULL,
    dataset_id uuid NOT NULL,
    created date DEFAULT CURRENT_DATE,
    created_by character varying(64),
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(64)
);
