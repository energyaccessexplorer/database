create or replace function private.upgrade_fail()
  returns trigger
  language plpgsql
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
begin
	raise exception 'You cannot upgrade roles above you.';
end $function$;

revoke all on function "private"."upgrade_fail"() from public;

grant execute on function "private"."upgrade_fail"() to "anon", "authenticated", "service_role";
