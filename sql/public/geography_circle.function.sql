--
-- Name: geography_circle(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geography_circle(uuid) RETURNS public.epiphet
    LANGUAGE sql IMMUTABLE
    AS $_$
	select circle from public.geographies where id = $1;
$_$;


--
-- Name: geography_circle(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geography_circle(public.datasets) RETURNS public.epiphet
    LANGUAGE sql IMMUTABLE
    AS $_$
	select public.geography_circle($1.geography_id);
$_$;
