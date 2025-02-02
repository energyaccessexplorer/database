--
-- Name: parent_sort_branches(public.geographies); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parent_sort_branches(public.geographies) RETURNS jsonb
    LANGUAGE sql IMMUTABLE
    AS $_$
	select obj from parent_configuration('sort_branches') t where t.id = $1.id;
$_$;
