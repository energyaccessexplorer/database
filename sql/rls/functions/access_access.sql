create or replace function rls.access_access (
  uid uuid,
  cir name,
  dep public.environments
)
  returns boolean
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select exists (
		select 1 from access
		where user_id = uid
			and circle = cir
			and deployment = dep
	)
$function$;

revoke all on function "rls"."access_access"(uuid, name, public.environments) from public;

grant execute on function "rls"."access_access"(uuid, name, public.environments) to "anon", "authenticated", "service_role";
