create table if not exists
	files (
	  id uuid primary key
	, label varchar(32) not null default current_timestamp::text
	, dataset_id uuid references datasets (id) not null
	, test boolean default true
	, endpoint text not null
	, comment text not null
	, created date
	, created_by varchar(64)
	, updated date
	, updated_by varchar(64)
	);

create function files_before_create()
returns trigger
language plpgsql immutable as $$ begin
	new.created = current_date;
	new.created_by = current_user;

	return new;
end $$;

create function files_before_update()
returns trigger
language plpgsql immutable as $$ begin
	new.updated = current_date;
	new.updated_by = current_user;

	if (new.test and not old.test) then
		raise exception '"test" attribute cannot be changed from "false" to "true"';
	end if;

	if (old.created_by != new.created_by) or (old.created != new.created) then
		raise exception '"created" and "created_by" are not editable assets.';
	end if;

	return new;
end $$;

create function files_before_delete()
returns trigger
language plpgsql immutable as $$ begin
	if not old.test then
		raise exception 'You cannot delete non-test files! This has to be done by an database admin by disabling this trigger.';
	end if;

	return old;
end $$;

create trigger insert_uuid
	before insert on files
	for each row
	execute procedure insert_uuid();

create trigger files_before_create
	before insert on files
	for each row
	execute procedure files_before_create();

create trigger files_before_update
	before update on files
	for each row
	execute procedure files_before_update();

create trigger files_before_delete
	before delete on files
	for each row
	execute procedure files_before_delete();

alter table datasets add column raster_file_id uuid references files (id);
alter table datasets add column vectors_file_id uuid references files (id);
alter table datasets add column csv_file_id uuid references files (id);
