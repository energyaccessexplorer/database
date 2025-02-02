--
-- Name: email_change_fail(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.email_change_fail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	raise exception 'You cannot change emails here.';
end $$;
