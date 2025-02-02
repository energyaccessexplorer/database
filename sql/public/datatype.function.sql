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


--
-- Name: datatype(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datatype(public.datasets) RETURNS public.epiphet
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
declare
	c categories;
	x epiphet;
begin
	select * from categories where id = $1.category_id into c;

	if (not c.mutant) then
		return datatype(c);
	end if;

	select d.datatype from datasets d
		where ($1.configuration->'mutant_targets'->>0) = any(array[d.category_name, d.name])
		and d.geography_id = $1.geography_id into x;

	return coalesce(x || '-', '') || 'mutant';
end
$_$;
