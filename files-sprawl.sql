create function files_geography_id(uuid)
returns uuid as $$
	select datasets.geography_id from public.datasets
		join public._datasets_files df on df.dataset_id = datasets.id
	where df.file_id = $1;
$$ language sql immutable;
alter table files add column geography_id uuid generated always as (files_geography_id(id)) stored;

alter table geographies add column boundary_file uuid references files (id);
alter table geographies rename constraint geographies_boundary_file_fkey to boundary;
