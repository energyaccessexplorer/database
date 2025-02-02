--
-- Name: datasets_flagged(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_flagged() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$ begin
	if (not old.flagged and new.flagged) then
		perform event_create('dataset:flagged', jsonb_build_object(
			'id', new.id,
			'last_updated_by', old.updated_by
		));
	end if;

	return new;
end $$;
