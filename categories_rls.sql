alter table categories enable row level security;

create policy public on categories
	for select
	to public
	using (true);

create policy superusers on categories
	using (current_role in ('master', 'root'));
