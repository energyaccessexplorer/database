--
-- Name: snapshot(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.snapshot(_time bigint) RETURNS TABLE("time" bigint, config jsonb, geography_id uuid, user_id uuid, title text)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
	select
		"time",
		config,
		geography_id,
		user_id,
		title
	from snapshots x
		where x."time" = _time;
$$;
