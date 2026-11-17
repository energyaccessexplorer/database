create or replace function public.category_name (
  public .datasets
)
  returns public.epiphet
  language sql
  stable
  AS $function$
	select name from categories where id = $1.category_id;
$function$;

grant execute on function "public"."category_name"(public.datasets) to public, "anon", "authenticated";

revoke all on function "public"."category_name"(public.datasets) from "postgres";

grant execute on function "public"."category_name"(public.datasets) to "postgres";

grant execute on function "public"."category_name"(public.datasets) to "service_role";
