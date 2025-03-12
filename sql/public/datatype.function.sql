--
-- Name: datatype(public.categories); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datatype(c public.categories) RETURNS public.epiphet
    LANGUAGE plpgsql IMMUTABLE
    AS $$
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
$$;
