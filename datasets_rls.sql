alter table datasets enable row level security;

create policy guest_select on datasets
	for select
	to public
	using (true);

create policy admin_all on datasets
	to admin
	using (admin_circle(geography_circle));

create policy superusers on datasets
	using (current_role in ('master', 'root'));
