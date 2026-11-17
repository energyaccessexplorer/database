create or replace function public.datasets_count (
  public .geographies
)
  returns bigint
  language sql
  stable
  AS $function$
	select count(1) from datasets where geography_id = $1.id;
$function$;

grant execute on function "public"."datasets_count"(public.geographies) to public, "anon", "authenticated";

revoke all on function "public"."datasets_count"(public.geographies) from "postgres";

grant execute on function "public"."datasets_count"(public.geographies) to "postgres";

grant execute on function "public"."datasets_count"(public.geographies) to "service_role";
