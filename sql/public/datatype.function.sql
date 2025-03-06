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
		return category_datatype(c);
	end if;

	select d.datatype from datasets d
		where ($1.configuration->'mutant_targets'->>0) = any(array[d.category_name, d.name])
		and d.geography_id = $1.geography_id into x;

	return coalesce(x || '-', '') || 'mutant';
end
$_$;
