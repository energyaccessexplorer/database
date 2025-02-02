--
-- Name: upgrade_fail(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.upgrade_fail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	raise exception 'You cannot upgrade roles above you.';
end $$;
