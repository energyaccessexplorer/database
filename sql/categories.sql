create table if not exists
	categories (
	  id uuid primary key default gen_random_uuid()
	, name epiphet unique not null
	, name_long varchar(64) not null
	, unit varchar(32)
	, raster jsonb default 'null'
	, vectors jsonb default 'null'
	, csv jsonb default 'null'
	, analysis jsonb default 'null'
	, timeline jsonb default 'null'
	, controls jsonb default 'null' -- fix this default
	, configuration jsonb default '{"path": [], "invert": []}'
	, metadata jsonb default '{"why": null}'
	);
