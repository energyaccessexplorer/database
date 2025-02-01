alter table geographies enable row level security;

-- PUBLIC / GUESTS

create policy public_select on geographies
	for select
	using (
		not flagged
		and ('production' = any(deployment))
	);

create policy guest_select on geographies
	for select
	using (
		not flagged
		and current_user_role() in ('guest')
		and envs_check(deployment)
		and circle_check(circle)
	);

-- ADMIN

create policy admin_select on geographies
	for select
	using (
		current_user_role() in ('admin')
		and circle_check(circle)
		and envs_check(deployment)
	);

create policy circles_deployments on geographies
	using (
		current_user_role() in ('leader', 'manager')
		and circle_check(circle)
		and envs_check(deployment)
	);

create policy superusers on geographies
	using (current_user_role() in ('director', 'root'));
