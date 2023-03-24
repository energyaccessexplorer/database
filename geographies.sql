create table geographies (
	  id uuid primary key default gen_random_uuid()
	, name varchar(64)
	, adm int
	, circle epiphet default 'public'
	, envelope float[4] default array[]::float[4]
	, check (
		envelope[1] >= -180 and
		envelope[3] <=  180 and
		envelope[1] < envelope[3] and
		envelope[2] >=  -90 and
		envelope[4] <=   90 and
		envelope[2] < envelope[4]
	)
	, resolution int default 1000
	, parent_id uuid references geographies (id)
	, configuration jsonb default jsonb_build_object(
		'boundaries_name', null,
		'timeline', false,
		'timeline_dates', null,
		'flag', null,
		'sort_branches', array[]::text[],
		'sort_subbranches', array[]::text[],
		'sort_datasets', array[]::text[]
		)
	, deployment environments[] default array[]::environments[]
	, flagged boolean default false
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

alter table geographies rename constraint geographies_parent_id_fkey to parent;

create function geography_circle(uuid)
returns epiphet as $$
	select circle from public.geographies where id = $1;
$$ language sql immutable;

create function has_subgeographies(geographies)
returns boolean as $$
	select coalesce((select true from geographies where parent_id = $1.id limit 1), false);
$$ language sql immutable;

create function parent_configuration(varchar)
returns table(id uuid, obj jsonb) as $$
	with recursive r as (
		select
			g.id,
			g.parent_id,
			nullif(g.configuration->$1, 'null') as obj
		from geographies g

	union
		select
			g.id,
			g.parent_id,
			coalesce(nullif(g.configuration->$1, 'null'), r.obj)
		from geographies g
		inner join r on r.id = g.parent_id

	) select id, obj from r where obj is not null;
$$ language sql;

create view geographies_tree_down as
with recursive tree as
(
	select id, parent_id, array[id] as path from geographies
	union all
	select c.id, c.parent_id, array_prepend(c.id, t.path) from geographies c
		inner join tree t on c.id = t.parent_id
)
select id, path from tree order by array_length(path,1) asc;

create view geographies_tree_up as
with recursive tree as
(
	select id, parent_id, array[id] as path from geographies
		where parent_id is null
	union all
	select c.id, c.parent_id, array_append(t.path, c.id) from geographies c
		inner join tree t on t.id = c.parent_id
)
select id, path from tree;

create function parent_sort_branches(geographies)
returns jsonb as $$
	select obj from parent_configuration('sort_branches') t where t.id = $1.id;
$$ language sql immutable;

create function parent_sort_subbranches(geographies)
returns jsonb as $$
	select obj from parent_configuration('sort_subbranches') t where t.id = $1.id;
$$ language sql immutable;

create function parent_sort_datasets(geographies)
returns jsonb as $$
	select obj from parent_configuration('sort_datasets') t where t.id = $1.id;
$$ language sql immutable;

create trigger geographies_flagged
	before update on geographies
	for each row
	execute procedure flagged();

create trigger geographies_before_create
	before insert on geographies
	for each row
	execute procedure before_any_create();

create trigger geographies_before_update
	before update on geographies
	for each row
	execute procedure before_any_update();
