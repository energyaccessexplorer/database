create or replace function public.has_subgeographies (
  public .geographies
)
  returns boolean
  language sql
  stable
  AS $function$
	select coalesce((select true from geographies where parent_id = $1.id limit 1), false);
$function$;

grant execute on function "public"."has_subgeographies"(public.geographies) to public, "anon", "authenticated";

revoke all on function "public"."has_subgeographies"(public.geographies) from "postgres";

grant execute on function "public"."has_subgeographies"(public.geographies) to "postgres";

grant execute on function "public"."has_subgeographies"(public.geographies) to "service_role";
