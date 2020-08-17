create table geographies (
	  id uuid primary key default gen_random_uuid()
	, name varchar(64)
	, adm int
	, cca3 varchar(3) not null
	, circle epiphet default 'public'
	, pack epiphet default 'all'
	, parent_id uuid references geographies (id)
	, online bool default false
	, configuration jsonb default 'null'
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

alter table geographies enable row level security;

create policy public_online on geographies
	for select to public
	using (circle in ('public') and online);

create policy superusers on geographies
	using (current_role in ('master', 'root'));

create trigger geographies_before_create
	before insert on geographies
	for each row
	execute procedure before_any_create();

create trigger geographies_before_update
	before update on geographies
	for each row
	execute procedure before_any_update();