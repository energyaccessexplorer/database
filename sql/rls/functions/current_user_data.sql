create or replace function rls.current_user_data (
  text
)
  returns jsonb
  language sql
  stable
  security definer
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select about -> $1 from public.users where id = auth.uid();
$function$;

revoke all on function "rls"."current_user_data"(text) from public;

grant execute on function "rls"."current_user_data"(text) to "anon", "authenticated", "service_role";
