--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    email text NOT NULL,
    about jsonb DEFAULT '{}'::jsonb,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rwid text,
    disabled boolean DEFAULT false,
    role public.roles DEFAULT 'guest'::public.roles,
    CONSTRAINT users_email_check CHECK ((email ~ '^[a-zA-Z0-9\''.+_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
    CONSTRAINT users_rwid_check CHECK ((rwid ~ '^[0-9a-f]{24}$'::text))
);
