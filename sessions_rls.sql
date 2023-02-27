alter table sessions enable row level security;

create policy root on sessions
	using (current_user_root());

create policy owner on sessions
	using (user_id = current_user_uuid());
