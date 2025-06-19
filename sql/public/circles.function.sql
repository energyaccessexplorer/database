--
-- Name: circles(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.circles(public.datasets) RETURNS public.epiphet[]
    LANGUAGE sql IMMUTABLE
    AS $_$
        select circles from public.geographies where id = $1.geography_id;
$_$;
