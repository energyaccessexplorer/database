--
-- Name: before_any_create(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.before_any_create() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$ begin
	new.created = current_timestamp;
	new.created_by = current_user_email();

	return new;
end $$;
