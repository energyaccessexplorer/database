--
-- Name: snapshot(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.snapshot(_time bigint) RETURNS TABLE("time" bigint, config jsonb, geography_id uuid, title text)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
	select
		x."time",
		x.config,
		s.geography_id,
		s.title
	from snapshots x
		join sessions s on s."time" = x.session_id
		where x."time" = _time;
$$;
