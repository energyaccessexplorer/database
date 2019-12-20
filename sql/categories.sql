create table if not exists
	categories (
	  id uuid primary key default gen_random_uuid()
	, name varchar(32) unique not null check (name ~ '^[a-z][a-z0-9\-]+$')
	, name_long varchar(64) not null
	, unit varchar(32)
	, weight smallint default 2
	, raster jsonb default 'null'
	, vectors jsonb default 'null'
	, metadata jsonb default '{"why": null}'
	);
