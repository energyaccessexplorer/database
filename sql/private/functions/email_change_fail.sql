create or replace function private.email_change_fail()
  returns trigger
  language plpgsql
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
begin
	raise exception 'You cannot change emails here.';
end $function$;

revoke all on function "private"."email_change_fail"() from public;

grant execute on function "private"."email_change_fail"() to "anon", "authenticated", "service_role";
