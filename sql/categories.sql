create table categories (
	  id uuid primary key default gen_random_uuid()
	, name epiphet unique not null
	, name_long varchar(64) not null
	, unit varchar(32)
	, raster jsonb default 'null'
	, vectors jsonb default 'null'
	, csv jsonb default 'null'
	, analysis jsonb default 'null'
	, timeline jsonb default 'null'
	, controls jsonb default jsonb_build_object(
		'range', null,
		'range_steps', null,
		'range_label', null,
		'path', array[]::text[],
		'weight', false
		)
	, configuration jsonb default jsonb_build_object(
		'path', array[]::text[],
		'invert', array[]::text[]
		)
	, metadata jsonb default jsonb_build_object(
		'why', null
		)
	);
