alter table geographies enable row level security;

create policy guest_select on geographies
	for select
	to guest
	using (true);

create policy adminguest_select on geographies
	for select
	to adminguest
	using ('production' = any(deployment));

create policy circles on geographies
	to admin
	using (circle_roles_check(circle, 'admin', 'leader'));

create policy superusers on geographies
	using (current_role in ('master', 'root'));
