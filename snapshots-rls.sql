alter table snapshots enable row level security;

create policy superusers on snapshots
	using (current_user_role() in ('director', 'root'));

create policy owner on snapshots
	using (user_id = current_user_id());
