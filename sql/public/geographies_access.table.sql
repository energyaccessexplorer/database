--
-- Name: geographies_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access (
    user_id uuid NOT NULL,
	table_name text NOT NULL,
    circle public.epiphet NOT NULL,
    deployment public.environments NOT NULL
);
