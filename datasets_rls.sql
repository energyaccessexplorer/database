alter table datasets enable row level security;

create policy public_select on datasets
	for select
	to public
	using (not flagged);

create policy circles on datasets
	to admin
	using (circle_roles_check(geography_circle, 'admin', 'leader', 'manager'));

create policy superusers on datasets
	using (current_role in ('master', 'root'));
