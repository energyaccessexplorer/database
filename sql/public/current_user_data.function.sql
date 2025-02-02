--
-- Name: current_user_data(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.current_user_data(text) RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    AS $_$
	select current_setting('user.data', true)::jsonb->$1;
$_$;
