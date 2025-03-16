--
-- Name: current_user_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_role() RETURNS public.roles
    LANGUAGE sql SECURITY DEFINER
    AS $$
	select current_setting('user.role', true)::roles;
$$;
