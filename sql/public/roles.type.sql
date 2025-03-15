--
-- Name: roles; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.roles AS ENUM (
    'guest',
    'guest-admin',
    'admin',
    'leader',
    'manager',
    'director',
    'root'
);
