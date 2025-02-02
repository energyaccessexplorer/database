--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    "time" bigint NOT NULL,
    user_id uuid NOT NULL,
    geography_id uuid,
    title text,
    env public.environments
);
