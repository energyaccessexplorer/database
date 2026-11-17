create or replace function rls.current_user_email()
  returns text
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select auth.jwt()->>'email';
$function$;

revoke all on function "rls"."current_user_email"() from public;

grant execute on function "rls"."current_user_email"() to "anon", "authenticated", "service_role";
