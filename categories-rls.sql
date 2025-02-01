alter table categories enable row level security;

create policy public on categories
	for select
	to public
	using (true);

create policy circles_deployments on categories
	using (
		current_user_role() in ('manager')
		and circle_check(circle)
		and envs_check(deployment)
	);

create policy superusers on categories
	using (current_user_role() in ('director', 'root'));
