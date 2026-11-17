create or replace function private.delete_self()
  returns trigger
  language plpgsql
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
begin
	raise 'Cannot delete yourself! Ask someone else to do it.';
end $function$;

revoke all on function "private"."delete_self"() from public;

grant execute on function "private"."delete_self"() to "anon", "authenticated", "service_role";
