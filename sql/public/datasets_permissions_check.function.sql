--
-- Name: datasets_permissions_check(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datasets_permissions_check(uid uuid, did uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	g geographies;
	d datasets;
begin
	select * from datasets where id = did into d;
	select * from geographies where id = d.geography_id into g;

 	return exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (g.circles)
			and a.deployment = ANY (g.deployment)
	);
end $$;
