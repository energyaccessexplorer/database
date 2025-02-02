alter table snapshots enable row level security;

create policy superusers on snapshots
	using (current_user_role() in ('director', 'root'));

create policy owner on snapshots
	using ((select exists (select 1 from sessions where time = session_id and user_id = current_user_id())));
