create or replace function rls.access_check (
  uid uuid,
  cir public.epiphet[],
  dep public.environments[]
)
  returns boolean
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (cir)
			and ((cardinality(dep) = 0) -- new/unpopulated
				 or a.deployment = ANY (dep))
	);
$function$;

revoke all on function "rls"."access_check"(uuid, public.epiphet[], public.environments[]) from public;

grant execute on function "rls"."access_check"(uuid, public.epiphet[], public.environments[]) to "anon", "authenticated", "service_role";
