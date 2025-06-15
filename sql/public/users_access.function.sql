--
-- Name: users_access(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.users_access(uid uuid, cid uuid) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
	select exists (
		select 1 from access
		where (circle, deployment) in (select circle, deployment from access where user_id = uid)
		and user_id = cid
	)
$$;
