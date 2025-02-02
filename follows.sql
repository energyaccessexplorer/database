create table follows (
	  user_id uuid references users (id) on delete cascade not null
	, dataset_id uuid references datasets (id) on delete cascade not null
	, unique (user_id, dataset_id)

	, created date default current_date
	, created_by varchar(64)
);

create function dataset_info(follows)
returns text as $$
	select info(d) from datasets d where id = $1.dataset_id;
$$ language sql immutable;

create trigger follows_before_create
	before insert on follows
	for each row
	execute procedure before_any_create();
