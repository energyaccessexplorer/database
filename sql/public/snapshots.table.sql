--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    "time" bigint,
    session_id bigint,
    config jsonb
);
