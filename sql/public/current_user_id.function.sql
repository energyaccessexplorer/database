--
-- Name: current_user_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_id() RETURNS uuid
    LANGUAGE sql SECURITY DEFINER
    AS $$
	select current_setting('user.id', true)::uuid;
$$;
