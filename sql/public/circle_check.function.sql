--
-- Name: circle_check(public.epiphet); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.circle_check(circlename public.epiphet) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
	select current_user_data('circles') ? circlename;
$$;
