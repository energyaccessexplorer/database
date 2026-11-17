create or replace function public.type (
  public .datasets
)
  returns public.epiphet
  language plpgsql
  stable
  AS $function$
declare
	c categories;
	x epiphet;
begin
	select * from categories where id = $1.category_id into c;

	if (not c.mutant) then
		return category_datatype(c);
	end if;

	select d.type from datasets d
		where ($1.mutant_configuration -> 'hosts' ->> 0) = any(array[d.category_name, d.name])
		and d.geography_id = $1.geography_id into x;

	return coalesce(x || '-', '') || 'mutant';
end
$function$;

grant execute on function "public"."type"(public.datasets) to public, "anon", "authenticated";

revoke all on function "public"."type"(public.datasets) from "postgres";

grant execute on function "public"."type"(public.datasets) to "postgres";

grant execute on function "public"."type"(public.datasets) to "service_role";
