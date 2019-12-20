create table if not exists
	datasets (
	  id uuid primary key default gen_random_uuid()
	, category_id uuid references categories (id) not null
	, geography_id uuid references geographies (id) not null
	, online bool default false
	, unique(category_id, geography_id)
	, presets jsonb
	, metadata jsonb default '{
	  "description": null,
	  "suggested_citation": null,
	  "cautions": null,
	  "spatial_resolution": null,
	  "license": null,
	  "sources": null,
	  "content_date": null,
	  "download_original_url": null,
	  "learn_more_url": null
	}'
	, configuration jsonb
	-- , raster_file uuid references files (id)   -- added in files.sql
	-- , vectors_file uuid references files (id)  -- added in files.sql
	-- , csv_file uuid references files (id)      -- added in files.sql
	);

alter table datasets enable row level security;
create policy online_policy on datasets using (online or (current_user in ('ea_admin')));


--
-- FETCHING
--

create function category_name(datasets)
returns text as $$
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

create or replace view geography_boundaries as
	select id, geography_id from datasets d where d.category_name = 'boundaries';

grant select on geography_boundaries to public;

