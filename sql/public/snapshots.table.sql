--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    "time" bigint,
    config jsonb,
    title text,
    env public.environments NOT NULL,
    user_id uuid NOT NULL,
    geography_id uuid NOT NULL
);
