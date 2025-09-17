--
-- Name: environments; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.environments AS ENUM (
    'test',
    'protected',
    'public',
    'training',
    'dev'
);
