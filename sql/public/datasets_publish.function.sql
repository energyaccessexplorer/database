--
-- Name: datasets_publish(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_publish() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
    p datasets_permissions;
begin
    if new.private = old.private and
        new.deployment @> old.deployment and
        new.deployment <@ old.deployment then
        return new;
    end if;

    select * from datasets_permissions where
        type = 'publish'::permission_types
        and dataset_id = new.id
        and user_id = current_user_id()
        into p;

    if p is null then
        raise exception 'No publish permission found';
    end if;

    return new;
end $$;
