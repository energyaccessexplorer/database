create or replace function rls.current_user_id()
  returns uuid
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select auth.uid();
$function$;

revoke all on function "rls"."current_user_id"() from public;

grant execute on function "rls"."current_user_id"() to "anon", "authenticated", "service_role";
