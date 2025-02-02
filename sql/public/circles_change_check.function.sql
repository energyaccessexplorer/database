--
-- Name: circles_change_check(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.circles_change_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	allowed_array text[] := array(select jsonb_array_elements_text(current_user_data('circles')))::text[];
	new_array text[] := array(select json_array_elements_text((new.data->'circles')::json))::text[];
	old_array text[] := array(select json_array_elements_text((old.data->'circles')::json))::text[];

	added text[];
	removed text[];
begin
	if (current_user_role() in ('director', 'root')) then
		return new;
	end if;

	select coalesce(array_agg(x), array[]::text[]) from unnest(new_array) x where x not in (select unnest(old_array)) into added;
	select coalesce(array_agg(x), array[]::text[]) from unnest(old_array) x where x not in (select unnest(new_array)) into removed;

	if ((added <@ allowed_array) and (removed <@ allowed_array)) then
		return new;
	end if;

	if (not added <@ allowed_array) then
		raise exception 'You cannot add users to circles you do not belong to yourself';
	end if;

	if (not removed <@ allowed_array) then
		raise exception 'You cannot remove users from circles you do not belong to yourself';
	end if;
end $$;
