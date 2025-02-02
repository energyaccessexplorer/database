--
-- Name: datasets_count(public.geographies); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_count(public.geographies) RETURNS bigint
    LANGUAGE sql
    AS $_$
	select count(1) from datasets where geography_id = $1.id;
$_$;
