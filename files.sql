create table files (
	  id uuid primary key default gen_random_uuid()
	, label varchar(32) not null default current_timestamp::text
	, configuration jsonb default 'null'
	, test boolean default true
	, endpoint text unique not null
	, comment text not null
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

create function files_before_delete()
returns trigger
language plpgsql immutable as $$ begin
	if not old.test then
		raise exception 'You cannot delete non-test files! This has to be done by an database admin by disabling this trigger.';
	end if;

	return old;
end $$;

create trigger before_any_create
	before insert on files
	for each row
	execute procedure before_any_create();

create trigger before_any_update
	before update on files
	for each row
	execute procedure before_any_update();

create trigger files_before_delete
	before delete on files
	for each row
	execute procedure files_before_delete();