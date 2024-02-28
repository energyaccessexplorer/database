alter table datasets enable row level security;

create policy public_select on datasets
	for select
	to public
	using (not flagged);

create policy circles_deployments on datasets
	to admin
	using (
		circle_roles_check(geography_circle(geography_id), 'admin', 'leader', 'manager')
		and (envs_check(deployment) or array_length(deployment,1) is null)
	);

create policy superusers on datasets
	using (current_role in ('director', 'root'));
