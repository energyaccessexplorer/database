create or replace function public.parent_sort_subbranches (
  public .geographies
)
  returns jsonb
  language sql
  stable
  AS $function$
	select obj from parent_configuration('sort_subbranches') t where t.id = $1.id;
$function$;

grant execute on function "public"."parent_sort_subbranches"(public.geographies) to public, "anon", "authenticated";

revoke all on function "public"."parent_sort_subbranches"(public.geographies) from "postgres";

grant execute on function "public"."parent_sort_subbranches"(public.geographies) to "postgres";

grant execute on function "public"."parent_sort_subbranches"(public.geographies) to "service_role";
