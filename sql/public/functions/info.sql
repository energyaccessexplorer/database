create or replace function public.info (
  public .datasets
)
  returns text
  language sql
  stable
  AS $function$
	select geography_name($1) || ' - ' || category_name($1);
$function$;

grant execute on function "public"."info"(public.datasets) to public, "anon", "authenticated";

revoke all on function "public"."info"(public.datasets) from "postgres";

grant execute on function "public"."info"(public.datasets) to "postgres";

grant execute on function "public"."info"(public.datasets) to "service_role";
