create or replace function public.geography_name (
  public .datasets
)
  returns text
  language sql
  stable
  AS $function$
	select name from geographies where id = $1.geography_id;
$function$;

grant execute on function "public"."geography_name"(public.datasets) to public, "anon", "authenticated";

revoke all on function "public"."geography_name"(public.datasets) from "postgres";

grant execute on function "public"."geography_name"(public.datasets) to "postgres";

grant execute on function "public"."geography_name"(public.datasets) to "service_role";
