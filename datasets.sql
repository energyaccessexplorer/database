create table datasets (
	  id uuid primary key default gen_random_uuid()
	, category_id uuid references categories (id) not null
	, geography_id uuid references geographies (id) not null
	, name epiphet default null
	, name_long text default null
	, unique(geography_id, name)
	, unique(geography_id, name_long)
	, unit text
	, pack epiphet default 'all'
	, geography_circle epiphet generated always as (geography_circle(geography_id)) stored
	, deployment environments[] default array[]::environments[]
	, flagged boolean default false
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
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

alter table datasets rename constraint datasets_geography_id_fkey to geography;
alter table datasets rename constraint datasets_category_id_fkey to category;

create trigger datasets_flagged
	before update on datasets
	for each row
	execute procedure flagged();

--
-- FETCHING
--

create function datatype(datasets)
returns epiphet as $$
declare
	category categories;

	vectors jsonb;
	raster jsonb;
	csv jsonb;

	mutant_targets jsonb;

	x epiphet;
	y epiphet;
begin
	select * from categories c where id = $1.category_id into category;

	if (category.name in ('outline', 'boundaries')) then
		return 'polygons-boundaries';
	end if;

	select ($1.configuration->>'mutant_targets') into mutant_targets;

	select category.vectors into vectors;
	select category.raster into raster;
	select category.csv into csv;

	select (case
	when (vectors <> 'null') then
		vectors->>'shape_type'
	when (raster <> 'null') then
		'raster'
	when (csv <> 'null') then
		'table'
	when (mutant_targets is not null) then
		(select d.datatype from datasets d
			where d.category_name = mutant_targets->>0
			and d.geography_id = $1.geography_id)
	else
		null
	end) into x;

	select (case
	when (mutant_targets is not null) then
		'mutant'
	when ($1.configuration->>'csv_columns' is not null) then
		'fixed'
	when (category.timeline <> 'null') then
		'timeline'
	else
		null
	end) into y;

	return x || coalesce('-' || y, '');
end
$$ language plpgsql immutable;

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

create trigger datasets_before_create
	before insert on datasets
	for each row
	execute procedure before_any_create();

create trigger datasets_before_update
	before update on datasets
	for each row
	execute procedure before_any_update();
