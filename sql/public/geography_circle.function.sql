--
-- Name: geography_circle(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geography_circle(public.datasets) RETURNS public.epiphet
    LANGUAGE sql IMMUTABLE
    AS $_$
	select circle from public.geographies where id = $1.geography_id;
$_$;
