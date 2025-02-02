--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    email text,
    dataset_id uuid NOT NULL,
    created date DEFAULT CURRENT_DATE,
    created_by character varying(64),
    user_id uuid NOT NULL
);
