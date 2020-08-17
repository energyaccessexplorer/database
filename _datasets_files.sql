create table _datasets_files (
	  dataset_id uuid references datasets (id) not null
	, file_id uuid references files (id) not null
	, func epiphet default null
	, active boolean default false
	);

create unique index _datasets_files_dataset_id_func_active_key on _datasets_files (dataset_id, func) where active;

alter table _datasets_files rename constraint _datasets_files_file_id_fkey to file;
alter table _datasets_files rename constraint _datasets_files_dataset_id_fkey to dataset;
