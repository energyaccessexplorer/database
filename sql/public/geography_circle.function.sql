--
-- Name: geography_circle(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geography_circle(public.datasets) RETURNS public.epiphet
    LANGUAGE sql IMMUTABLE
    AS $_$
	select public.geography_circle($1.geography_id);
$_$;
