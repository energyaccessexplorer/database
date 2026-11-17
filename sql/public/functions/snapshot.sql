create or replace function public.snapshot (
  _time bigint
)
  returns table (
    "time"       bigint,
    config       jsonb,
    geography_id uuid,
    user_id      uuid,
    title        text
  )
  language sql
  stable
  security definer
  set search_path to 'public', 'pg_catalog'
  AS $function$
	select
		"time",
		config,
		geography_id,
		user_id,
		title
	from snapshots x
		where x."time" = _time;
$function$;

grant execute on function "public"."snapshot"(bigint) to public, "anon", "authenticated";

revoke all on function "public"."snapshot"(bigint) from "postgres";

grant execute on function "public"."snapshot"(bigint) to "postgres";

grant execute on function "public"."snapshot"(bigint) to "service_role";
