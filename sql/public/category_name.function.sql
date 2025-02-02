--
-- Name: category_name(public.datasets); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.category_name(public.datasets) RETURNS public.epiphet
    LANGUAGE sql
    AS $_$
	select name from categories where id = $1.category_id;
$_$;
