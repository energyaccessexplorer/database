--
-- Name: flagged(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.flagged() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$ begin
	if (new.flagged and array_position(new.deployment, 'production') > -1) then
		new.deployment = array_remove(new.deployment, 'production');
		raise notice 'Flagged row. Removed "production" from deployment.';
	end if;

	return new;
end $$;
