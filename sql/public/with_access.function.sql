--
-- Name: with_access(public.geographies); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.with_access(public.geographies) RETURNS boolean
    LANGUAGE sql
    AS $_$
	select exists (
		select 1 from access a
			where user_id = current_user_id()
			and circle = ANY ($1.circles)
	)
$_$;
