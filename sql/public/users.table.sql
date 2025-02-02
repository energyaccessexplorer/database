--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    email text NOT NULL,
    about jsonb DEFAULT '{}'::jsonb,
    role name DEFAULT 'guest'::name,
    data jsonb DEFAULT '{"envs": [], "circles": []}'::jsonb,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rwid text,
    disabled boolean DEFAULT false,
    CONSTRAINT users_email_check CHECK ((email ~ '^[a-zA-Z0-9\''.+_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
    CONSTRAINT users_role_check CHECK ((role = ANY (ARRAY['root'::name, 'director'::name, 'manager'::name, 'leader'::name, 'admin'::name, 'guest'::name]))),
    CONSTRAINT users_rwid_check CHECK ((rwid ~ '^[0-9a-f]{24}$'::text))
);
