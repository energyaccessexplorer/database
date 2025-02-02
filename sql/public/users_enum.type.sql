--
-- Name: users_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_enum AS ENUM (
    'guest',
    'admin',
    'leader',
    'manager',
    'director',
    'root'
);
