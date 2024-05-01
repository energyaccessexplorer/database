alter table follows enable row level security;

create policy superusers on follows
	using (current_role in ('director', 'root'));
