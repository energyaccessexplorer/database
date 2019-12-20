create table if not exists
	geographies (
	  id uuid primary key default gen_random_uuid()
	, name varchar(64)
	, adm int
	, cca3 varchar(3) not null
	, parent_id uuid references geographies (id)
	, online bool default false
	, configuration jsonb default 'null'
	);

