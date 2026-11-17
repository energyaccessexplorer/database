create or replace function public.with_access (
  public .geographies
)
  returns boolean
  language sql
  stable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
	select exists (
		select 1 from access a
			where user_id = current_user_id()
			and circle = ANY ($1.circles)
	)
$function$;

grant execute on function "public"."with_access"(public.geographies) to public, "anon", "authenticated";

revoke all on function "public"."with_access"(public.geographies) from "postgres";

grant execute on function "public"."with_access"(public.geographies) to "postgres";

grant execute on function "public"."with_access"(public.geographies) to "service_role";
