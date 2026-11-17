create or replace function public.datatype (
  c public.categories
)
  returns public.epiphet
  language plpgsql
  immutable
  AS $function$
declare
	x epiphet;
	y epiphet;
begin
	if (c.name in ('outline', 'boundaries')) then
		return 'polygons-boundaries';
	end if;

	select (case
	when (c.vectors <> 'null') then
		c.vectors->>'shape_type'
	when (c.raster <> 'null') then
		'raster'
	when (c.csv <> 'null') then
		'table'
	when (c.mutant) then
		'mutant'
	else
		null
	end) into x;

	select (case
	when (c.timeline <> 'null') then
		'timeline'
	when (x <> 'table' and c.csv <> 'null') then
		'valued'
	else
		null
	end) into y;

	return x || coalesce('-' || y, '');
end
$function$;

grant execute on function "public"."datatype"(public.categories) to public, "anon", "authenticated";

revoke all on function "public"."datatype"(public.categories) from "postgres";

grant execute on function "public"."datatype"(public.categories) to "postgres";

grant execute on function "public"."datatype"(public.categories) to "service_role";
