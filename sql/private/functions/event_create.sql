create or replace function private.event_create (
  trgr    text,
  payload jsonb
)
  returns jsonb
  language plpgsql
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
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
end $function$;

revoke all on function "private"."event_create"(text, jsonb) from public;

grant execute on function "private"."event_create"(text, jsonb) to "anon", "authenticated", "service_role";
