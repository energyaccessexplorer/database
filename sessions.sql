create table sessions (
	  time bigint primary key
	, geography_id uuid references geographies (id)
	, user_id uuid not null
	, env environments
	, title text
	, unique (title, user_id)
);
