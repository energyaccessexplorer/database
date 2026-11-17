create or replace function private.before_any_create()
  returns trigger
  language plpgsql
  immutable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	new.created = current_timestamp;
	new.created_by = current_user_email();

	return new;
end $function$;

revoke all on function "private"."before_any_create"() from public;

grant execute on function "private"."before_any_create"() to "anon", "authenticated", "service_role";
