create or replace function public.circles (
  public .datasets
)
  returns public.epiphet[]
  language sql
  stable
  AS $function$
        select circles from public.geographies where id = $1.geography_id;
$function$;

grant execute on function "public"."circles"(public.datasets) to public, "anon", "authenticated";

revoke all on function "public"."circles"(public.datasets) from "postgres";

grant execute on function "public"."circles"(public.datasets) to "postgres";

grant execute on function "public"."circles"(public.datasets) to "service_role";
