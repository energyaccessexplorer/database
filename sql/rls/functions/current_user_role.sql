create or replace function rls.current_user_role()
  returns public.roles
  language sql
  stable
  security definer
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select coalesce(
		(select role from public.users where id = auth.uid()),
		'guest'::public.roles
	);
$function$;

revoke all on function "rls"."current_user_role"() from public;

grant execute on function "rls"."current_user_role"() to "anon", "authenticated", "service_role";
