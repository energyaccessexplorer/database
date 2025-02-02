--
-- Name: current_user_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_email() RETURNS text
    LANGUAGE sql SECURITY DEFINER
    AS $$
	select current_setting('user.email', true)::text;
$$;
