--
-- Name: envs_check(public.environments[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.envs_check(envs public.environments[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
	select current_user_data('envs') ?| envs::text[];
$$;
