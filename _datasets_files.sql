create table _datasets_files (
	  dataset_id uuid references datasets (id) not null
	, file_id uuid references files (id) not null
	, unique(dataset_id, file_id)
	, func epiphet default null
	, active boolean default false
	, geography_id uuid generated always as (_datasets_files_geography_id(dataset_id)) stored
	);

alter table _datasets_files rename constraint _datasets_files_file_id_fkey to file;
alter table _datasets_files rename constraint _datasets_files_dataset_id_fkey to dataset;

create or replace function _datasets_files_geography_id(uuid)
returns uuid as $$
	select geography_id from datasets where id = $1;
$$ language sql immutable;
