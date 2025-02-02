--
-- Name: parent_sort_subbranches(public.geographies); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parent_sort_subbranches(public.geographies) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$
	select obj from parent_configuration('sort_subbranches') t where t.id = $1.id;
$_$;
