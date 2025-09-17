--
-- Name: access_check(uuid, public.epiphet[], public.environments[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.access_check(uid uuid, cir public.epiphet[], dep public.environments[]) RETURNS boolean
    LANGUAGE sql
    AS $$
	select exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (cir)
			and ((cardinality(dep) = 0) -- new/unpopulated
				 or a.deployment = ANY (dep))
	);
$$;
