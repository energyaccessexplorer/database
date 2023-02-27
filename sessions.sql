create table sessions (
	  time bigint primary key
	, user_id uuid not null
	, geography_id uuid references geographies (id)
	);
