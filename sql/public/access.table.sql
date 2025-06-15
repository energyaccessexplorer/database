--
-- Name: access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.access (
    user_id uuid NOT NULL,
    circle public.epiphet NOT NULL,
    deployment public.environments NOT NULL
);
