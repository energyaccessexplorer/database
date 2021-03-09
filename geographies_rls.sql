alter table geographies enable row level security;

create policy public on geographies
	for select
	to public
	using (true);

create policy admins_insert on geographies
	for insert
	with check (admin_circle(circle));

create policy admins_update on geographies
	for update
	using (admin_circle(circle));

create policy admins_delete on geographies
	for delete
	using (admin_circle(circle));

create policy superusers on geographies
	for all
	using (current_role in ('master', 'root'));
