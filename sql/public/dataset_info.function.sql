--
-- Name: dataset_info(public.follows); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dataset_info(public.follows) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
	select info(d) from datasets d where id = $1.dataset_id;
$_$;
