alter table sessions enable row level security;

create policy superusers on sessions
	using (current_user_role() in ('director', 'root'));

create policy owner on sessions
	using (user_id = current_user_id());
