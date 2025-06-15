--
-- Name: access_access(uuid, name, public.environments); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.access_access(uid uuid, cir name, dep public.environments) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
	select exists (
		select 1 from access
		where user_id = uid
			and circle = cir
			and deployment = dep
	)
$$;
