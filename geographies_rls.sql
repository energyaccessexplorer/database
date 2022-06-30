alter table geographies enable row level security;

create policy public_select on geographies
	for select
	to public
	using (not flagged and ('production' = any(deployment)));

create policy adminguest_select on geographies
	for select
	to adminguest
	using ('production' = any(deployment));

create policy circles on geographies
	to admin
	using (circle_roles_check(circle, 'admin', 'leader'));

create policy envs on geographies
	to admin
	using (envs_check(deployment));

create policy superusers on geographies
	using (current_role in ('master', 'root'));
