create or replace function public.dataset_info (
  public .follows
)
  returns text
  language sql
  stable
  AS $function$
	select info(d) from datasets d where id = $1.dataset_id;
$function$;

grant execute on function "public"."dataset_info"(public.follows) to public, "anon", "authenticated";

revoke all on function "public"."dataset_info"(public.follows) from "postgres";

grant execute on function "public"."dataset_info"(public.follows) to "postgres";

grant execute on function "public"."dataset_info"(public.follows) to "service_role";
