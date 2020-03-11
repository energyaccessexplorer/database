create table datasets (
	  id uuid primary key default gen_random_uuid()
	, category_id uuid references categories (id) not null
	, geography_id uuid references geographies (id) not null
	, name epiphet unique default null
	, name_long text unique default null
	, unique(category_id, geography_id, name)
	, unit text
	, pack epiphet default 'all'
	, circle epiphet default 'public'
	, online bool default false
	, presets jsonb default 'null'
	, configuration jsonb default 'null'
	, category_overrides jsonb default 'null'
	, metadata jsonb default jsonb_build_object(
	  'description', null,
	  'suggested_citation', null,
	  'cautions', null,
	  'spatial_resolution', null,
	  'license', null,
	  'sources', null,
	  'content_date', null,
	  'download_original_url', null,
	  'learn_more_url', null
	)
	-- , raster_file uuid references files (id)   -- added in files.sql
	-- , vectors_file uuid references files (id)  -- added in files.sql
	-- , csv_file uuid references files (id)      -- added in files.sql
	);

--
-- ROW-LEVEL SECURITY
--

alter table datasets enable row level security;

create policy public_online on datasets
	for select to public
	using (circle in ('public') and online);

create policy circle_role on datasets
	using (circle in (current_role));

create policy superusers on datasets
	using (current_role in ('master', 'root'));

--
-- FETCHING
--

create function category_name(datasets)
returns epiphet as $$
	select name from categories where id = $1.category_id;
$$ language sql;

create function geography_name(datasets)
returns text as $$
	select name from geographies where id = $1.geography_id;
$$ language sql;

create function datasets_count(geographies)
returns bigint as $$
	select count(1) from datasets where geography_id = $1.id;
$$ language sql;

create view geography_boundaries as
	select id, geography_id from datasets d where d.category_name = 'boundaries';


