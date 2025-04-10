--
-- Name: datasets_allowed(uuid, public.permission_types); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_allowed(did uuid, typ public.permission_types) RETURNS boolean
    LANGUAGE sql IMMUTABLE SECURITY DEFINER
    AS $$
select exists (
    select 1 from datasets_permissions where
        user_id = current_user_id()
        and dataset_id = did
        and "type" = typ
)
$$;
