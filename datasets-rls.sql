alter table datasets enable row level security;

create policy public_select on datasets
	for select
	using (
		not flagged
		and ('production' = any(deployment))
	);

create policy circles_deployments on datasets
	using (
		current_user_role() in ('admin', 'leader', 'manager')
		and circle_check(geography_circle(geography_id))
		and (envs_check(deployment) or (array_length(deployment,1) is null))
	);

create policy superusers on datasets
	using (current_user_role() in ('director', 'root'));
