create table sessions (
	  time bigint primary key
	, geography_id uuid references geographies (id)
	, user_id uuid not null
	, env environments
	, check (env is null or array_position(enum_range(null::environments), env) > 0)
	, title text
	, unique(title, user_id)
	);
