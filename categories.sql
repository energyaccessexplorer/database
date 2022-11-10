create table categories (
	  id uuid primary key default gen_random_uuid()
	, name epiphet unique not null
	, name_long varchar(64) not null
	, unit varchar(32)
	, circle epiphet default 'everywhere'
	, deployment environments[] default array[]::environments[]
	, domain jsonb default 'null'
	, domain_init jsonb default 'null'
	, colorstops jsonb default 'null'
	, raster jsonb default 'null'
	, vectors jsonb default 'null'
	, csv jsonb default 'null'
	, analysis jsonb default 'null'
	, timeline jsonb default 'null'
	, mutant boolean default false
	, controls jsonb default jsonb_build_object(
		'range', null,
		'range_steps', null,
		'range_label', null,
		'path', array[]::text[],
		'weight', false
		)
	, description text
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

create function datatype(c categories)
returns epiphet as $$
declare
	x epiphet;
	y epiphet;
begin
	if (c.name in ('outline', 'boundaries')) then
		return 'polygons-boundaries';
	end if;

	select (case
	when (c.vectors <> 'null') then
		c.vectors->>'shape_type'
	when (c.raster <> 'null') then
		'raster'
	when (c.csv <> 'null') then
		'table'
	when (c.mutant) then
		'mutant'
	else
		null
	end) into x;

	select (case
	when (c.timeline <> 'null') then
		'timeline'
	when (x <> 'table' and c.csv <> 'null') then
		'fixed'
	else
		null
	end) into y;

	return x || coalesce('-' || y, '');
end
$$ language plpgsql immutable;

create function categories_before_update()
returns trigger as $$
begin
	if ((current_role not in ('master', 'root')) and 'production' = any(new.deployment)) then
		raise exception 'You are do not have enough permissions to edit categories in production';
	end if;

	return new;
end
$$ language plpgsql;

create trigger categories_deployments
	before insert or update on categories
	for each row
	execute procedure categories_before_update();

create trigger categories_before_create
	before insert on categories
	for each row
	execute procedure before_any_create();

create trigger categories_before_update
	before update on categories
	for each row
	execute procedure before_any_update();
