create table snapshots (
	  time bigint
	, session_id bigint references sessions (time) on delete cascade
	, config jsonb default null
	, unique(session_id, time)
	);
