alter table geographies enable row level security;

create policy guest_select on geographies
	for select
	to guest
	using (true);

create policy adminguest_select on geographies
	for select
	to adminguest
	using ('production' = any(deployment));

create policy admin_all on geographies
	to admin
	using (admin_circle(circle));

create policy superusers on geographies
	using (current_role in ('master', 'root'));
