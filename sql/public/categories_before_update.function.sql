--
-- Name: categories_before_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.categories_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	if ((current_user_role() not in ('director', 'root')) and 'production' = any(new.deployment)) then
		raise exception 'You are do not have enough permissions to edit categories in production';
	end if;

	return new;
end
$$;
