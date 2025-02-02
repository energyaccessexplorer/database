--
-- Name: parent_configuration(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parent_configuration(character varying) RETURNS TABLE(id uuid, obj jsonb)
    LANGUAGE sql
    AS $_$
	with recursive r as (
		select
			g.id,
			g.parent_id,
			nullif(g.configuration->$1, 'null') as obj
		from geographies g

	union
		select
			g.id,
			g.parent_id,
			coalesce(nullif(g.configuration->$1, 'null'), r.obj)
		from geographies g
		inner join r on r.id = g.parent_id

	) select id, obj from r where obj is not null;
$_$;
