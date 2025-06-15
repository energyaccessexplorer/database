--
-- Name: datasets_publish(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_publish() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
	added environments[];
	removed environments[];
	allowed environments[];
begin
	if current_user_role() > 'manager'::roles then
		return new;
	end if;

    if true and
        new.deployment @> old.deployment and
        new.deployment <@ old.deployment then
        return new;
    end if;

	select array_agg(x) from unnest(new.deployment) x where x not in (select unnest(old.deployment)) into added;
	select array_agg(x) from unnest(old.deployment) x where x not in (select unnest(new.deployment)) into removed;

	select array_agg(deployment) from access a where
		a.user_id = current_user_id()
		and a.circle = circle(new)
	into allowed;

	if ((added <@ allowed) and (removed <@ allowed)) then
		return new;
	end if;

	if (not added <@ allowed) then
		raise exception 'You cannot add access you do not belong to yourself';
	end if;

	if (not removed <@ allowed) then
		raise exception 'You cannot remove access you do not belong to yourself';
	end if;

    return new;
end $$;
