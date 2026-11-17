create or replace function rls.datasets_allowed (
  did uuid,
  typ public.permission_types
)
  returns boolean
  language sql
  stable
  security definer
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
select exists (
    select 1 from datasets_permissions where
        user_id = current_user_id()
        and dataset_id = did
        and "type" = typ
)
$function$;

revoke all on function "rls"."datasets_allowed"(uuid, public.permission_types) from public;

grant execute on function "rls"."datasets_allowed"(uuid, public.permission_types) to "anon", "authenticated", "service_role";
