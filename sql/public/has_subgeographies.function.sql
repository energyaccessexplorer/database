--
-- Name: has_subgeographies(public.geographies); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_subgeographies(public.geographies) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
	select coalesce((select true from geographies where parent_id = $1.id limit 1), false);
$_$;
