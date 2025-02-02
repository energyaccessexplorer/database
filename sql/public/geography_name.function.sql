--
-- Name: geography_name(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geography_name(public.datasets) RETURNS text
    LANGUAGE sql
    AS $_$
	select name from geographies where id = $1.geography_id;
$_$;
