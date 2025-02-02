--
-- Name: event_create(text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.event_create(trgr text, payload jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
declare
	message jsonb;

begin
	message = jsonb_build_object(
		'id', current_timestamp,
		'trigger', trgr,
		'payload', payload
	);

	insert into events_queue (message) values (message);

	perform pg_notify('events', message::text);

	return message;
end $$;
