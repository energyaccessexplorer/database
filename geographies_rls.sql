alter table geographies enable row level security;

-- PUBLIC / GUESTS

create policy public_select on geographies
	for select
	to public
	using (not flagged and ('production' = any(deployment)));

create policy guest_select on geographies
	for select
	to guest
	using (not flagged and envs_check(deployment) and circle_roles_check(circle, 'guest'));

create policy adminguest_select on geographies
	for select
	to adminguest
	using ('production' = any(deployment));

-- ADMIN

create policy circles_deployments on geographies
	to admin
	using (
		circle_roles_check(circle, 'admin', 'leader', 'manager')
		and envs_check(deployment)
	);

create policy superusers on geographies
	using (current_role in ('director', 'root'));
