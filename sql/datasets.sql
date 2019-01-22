create table if not exists
	datasets (
		id uuid primary key
	,	category_name varchar(32) not null
	, category_id uuid references categories (id) not null
	, country_id uuid references countries (id) not null
	, online bool default false
	,	unique(category_id, country_id)
	, presets jsonb
	, metadata jsonb default '{
		"description": null,
		"suggested_citation": null,
		"cautions": null,
		"spatial_resolution": null,
		"license": null,
		"sources": null,
		"content_date": 0,
		"download_original_url": null,
		"learn_more_url": null
	}'
	, configuration jsonb

	-- , heatmap_file uuid references files (id)  -- added in files.sql
	-- , vectors_file uuid references files (id)  -- added in files.sql
	-- , csv_file uuid references files (id)      -- added in files.sql
	);

alter table datasets enable row level security;
create policy online_policy on datasets using (online or (current_user in ('ea_admin')));

create function insert_category_name()
returns trigger
language plpgsql as $$ begin
	new.category_name = (select name from categories where id = new.category_id);
	return new;
end $$;

create trigger insert_uuid
	before insert on datasets
	for each row
	execute procedure insert_uuid();

create trigger insert_category_name
	before insert on datasets
	for each row
	execute procedure insert_category_name();

