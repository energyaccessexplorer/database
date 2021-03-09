alter table datasets enable row level security;

create policy public on datasets
	for select
	to public
	using (true);

create policy admins_insert on datasets
	for insert
	with check (admin_circle(geography_circle));

create policy admins_update on datasets
	for update
	using (admin_circle(geography_circle));

create policy admins_delete on datasets
	for delete
	using (admin_circle(geography_circle));

create policy superusers on datasets
	using (current_role in ('master', 'root'));
