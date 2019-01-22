create table if not exists
	countries (
		id uuid primary key
	, name varchar(64)
	, cca3 varchar(3)
	, ccn3 integer unique not null
	, online bool default false
	, bounds jsonb default '[[0,0], [0,0]]'
	, category_tree jsonb default null
	, metadata jsonb default '{}'
	);

create trigger insert_uuid
	before insert on countries
	for each row
	execute procedure insert_uuid();
