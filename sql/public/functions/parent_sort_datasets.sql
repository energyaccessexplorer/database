create or replace function public.parent_sort_datasets (
  public .geographies
)
  returns jsonb
  language sql
  stable
  AS $function$
	select obj from parent_configuration('sort_datasets') t where t.id = $1.id;
$function$;

grant execute on function "public"."parent_sort_datasets"(public.geographies) to public, "anon", "authenticated";

revoke all on function "public"."parent_sort_datasets"(public.geographies) from "postgres";

grant execute on function "public"."parent_sort_datasets"(public.geographies) to "postgres";

grant execute on function "public"."parent_sort_datasets"(public.geographies) to "service_role";
