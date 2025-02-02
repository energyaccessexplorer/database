create table snapshots (
	  time bigint
	, session_id bigint references sessions (time) on delete cascade
	, config jsonb default null
	, unique(session_id, time)
	);

create function public.snapshot(_time bigint)
returns table(
	"time" bigint,
	config jsonb,
	geography_id uuid,
	title text
)
language sql security definer stable
as $$
	select
		x."time",
		x.config,
		s.geography_id,
		s.title
	from snapshots x
		join sessions s on s."time" = x.session_id
		where x."time" = _time;
$$;
