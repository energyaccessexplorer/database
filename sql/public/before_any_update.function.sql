--
-- Name: before_any_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.before_any_update() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$ begin
	if (old.updated_by != new.updated_by) or
		(old.created_by != new.created_by) or
		(old.updated != new.updated) or
		(old.created != new.created)
	then
		raise exception 'Columns "updated", "updated_by", "created" and "created_by" are not editable';
	end if;

	new.updated = current_timestamp;
	new.updated_by = current_user_email();

	return new;
end $$;
