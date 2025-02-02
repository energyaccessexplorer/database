--
-- Name: circle_roles_check(public.epiphet, name[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.circle_roles_check(circlename public.epiphet, VARIADIC rolenames name[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
	select ((current_role in (select unnest(rolenames))) and
		current_setting('request.jwt.claims', true)::jsonb->'data'->'circles' ? circlename);
$$;
