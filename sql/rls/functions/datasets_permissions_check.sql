create or replace function rls.datasets_permissions_check (
  uid uuid,
  did uuid
)
  returns boolean
  language plpgsql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
declare
	g geographies;
	d datasets;
begin
	select * from datasets where id = did into d;
	select * from geographies where id = d.geography_id into g;

 	return exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (g.circles)
			and a.deployment = ANY (g.deployment)
	);
end $function$;

revoke all on function "rls"."datasets_permissions_check"(uuid, uuid) from public;

grant execute on function "rls"."datasets_permissions_check"(uuid, uuid) to "anon", "authenticated", "service_role";
