create or replace function rls.users_access (
  uid uuid,
  cid uuid
)
  returns boolean
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select exists (
		select 1 from access
		where (circle, deployment) in (select circle, deployment from access where user_id = uid)
		and user_id = cid
	)
$function$;

revoke all on function "rls"."users_access"(uuid, uuid) from public;

grant execute on function "rls"."users_access"(uuid, uuid) to "anon", "authenticated", "service_role";
