create table if not exists
	geographies (
	  id uuid primary key default gen_random_uuid()
	, name varchar(64)
	, adm int
	, cca3 varchar(3) not null
	, circle name default 'public'
	, parent_id uuid references geographies (id)
	, online bool default false
	, configuration jsonb default 'null'
	);

alter table geographies enable row level security;

create policy public_online on geographies
	for select to public
	using (circle in ('public') and online);

create policy superusers on geographies
	using (current_role in ('master', 'root'));
