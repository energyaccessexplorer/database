create table files (
	  id uuid primary key default gen_random_uuid()
	, label varchar(32) not null default current_timestamp::text
	, configuration jsonb default 'null'
	, endpoint text unique not null
	, comment text not null
	, geography_id uuid generated always as (files_geography_id(id)) stored
	, created date default current_date
	, created_by varchar(64)
	, updated timestamp with time zone default current_timestamp
	, updated_by varchar(64)
	);

create function files_geography_id(uuid)
returns uuid as $$
	select d.geography_id from datasets d
		join _datasets_files df on df.dataset_id = d.id
	where df.file_id = $1;
$$ language sql immutable;

create trigger before_any_create
	before insert on files
	for each row
	execute procedure before_any_create();

create trigger before_any_update
	before update on files
	for each row
	execute procedure before_any_update();
