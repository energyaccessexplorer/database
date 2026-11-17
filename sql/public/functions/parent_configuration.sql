create or replace function public.parent_configuration (
  character varying
)
  returns table (
    id  uuid,
    obj jsonb
  )
  language sql
  stable
  AS $function$
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
$function$;

grant execute on function "public"."parent_configuration"(character varying) to public, "anon", "authenticated";

revoke all on function "public"."parent_configuration"(character varying) from "postgres";

grant execute on function "public"."parent_configuration"(character varying) to "postgres";

grant execute on function "public"."parent_configuration"(character varying) to "service_role";
