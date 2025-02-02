--
-- Name: delete_self(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_self() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	raise 'Cannot delete yourself! Ask someone else to do it.';
end $$;
