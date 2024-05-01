create table datasets (
	  id uuid primary key default gen_random_uuid()
	, category_id uuid references categories (id) on delete cascade not null
	, geography_id uuid references geographies (id) on delete cascade not null
	, name epiphet default null
	, name_long text default null
	, unique(geography_id, name)
	, unique(geography_id, name_long)
	, deployment environments[] default array[]::environments[]
	, flagged boolean default false
	, configuration jsonb default 'null'
	, category_overrides jsonb default 'null'
	, source_files jsonb default '[]'
	, processed_files jsonb default '[]'
	, notification_lastest date
	, notification_interval text
	, check(notification_interval ~ '^[0-9]{1,2} (day|week|month|year)s?$')
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

create or replace function datasets_flagged()
returns trigger
language plpgsql immutable as $$ begin
	if (not old.flagged and new.flagged) then
		perform event_create('dataset:flagged', jsonb_build_object(
			'id', new.id,
			'last_updated_by', old.updated_by
		));
	end if;

	return new;
end $$;

create trigger datasets_flagged_notify
	before update on datasets
	for each row
	execute procedure datasets_flagged();

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
		where ($1.configuration->'mutant_targets'->>0) = any(array[d.category_name, d.name])
		and d.geography_id = $1.geography_id into x;

	return coalesce(x || '-', '') || 'mutant';
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

create function info(datasets)
returns text as $$
	select geography_name($1) || ' - ' || category_name($1);
$$ language sql immutable;

create trigger datasets_before_create
	before insert on datasets
	for each row
	execute procedure before_any_create();

create trigger datasets_before_update
	before update on datasets
	for each row
	execute procedure before_any_update();
