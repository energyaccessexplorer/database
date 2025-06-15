--
-- Name: access_check(uuid, name, public.environments[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.access_check(uid uuid, cir name, dep public.environments[]) RETURNS boolean
    LANGUAGE sql
    AS $$
 	select exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = cir
			and a.deployment in (select unnest(dep))
	);
$$;
