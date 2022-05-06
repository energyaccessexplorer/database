create table datasets (
	  id uuid primary key default gen_random_uuid()
	, category_id uuid references categories (id) on delete cascade not null
	, geography_id uuid references geographies (id) on delete cascade not null
	, name epiphet default null
	, name_long text default null
	, unique(geography_id, name)
	, unique(geography_id, name_long)
	, geography_circle epiphet generated always as (geography_circle(geography_id)) stored
	, deployment environments[] default array[]::environments[]
	, flagged boolean default false
	, configuration jsonb default 'null'
	, category_overrides jsonb default 'null'
	, source_files jsonb default '[]'
	, processed_files jsonb default '[]'
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
	c categories;
	x epiphet;
begin
	select * from categories where id = $1.category_id into c;

	if (not c.mutant) then
		return datatype(c);
	end if;

	select d.datatype from datasets d
		where d.category_name = $1.configuration->'mutant_targets'->>0
		and d.geography_id = $1.geography_id into x;

	return x || '-mutant';
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
