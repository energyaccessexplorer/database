--
-- Name: info(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.info(public.datasets) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
	select geography_name($1) || ' - ' || category_name($1);
$_$;
