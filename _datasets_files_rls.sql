alter table _datasets_files enable row level security;

create policy guest_select on _datasets_files
	for select
	to guest
	using (active);

create policy admin_all on _datasets_files
	to admin
	using (true);
