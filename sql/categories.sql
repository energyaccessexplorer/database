create table if not exists
	categories (
	  id uuid primary key
	, name varchar(32) unique not null
	, name_long varchar(64) not null
	, unit varchar(32)
	, weight smallint default 2
	, heatmap jsonb default 'null'
	, vectors jsonb default 'null'
	, metadata jsonb default '{"why": null, "path": [], "invert": []}'
	);

create trigger insert_uuid
	before insert on categories
	for each row
	execute procedure insert_uuid();
