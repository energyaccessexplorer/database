create table if not exists
	categories (
	  id uuid primary key
	, name varchar(32) unique not null
	, name_long varchar(64) not null
	, unit varchar(32)
	, weight smallint default 2
	, heatmap jsonb default '{
	  "number_type": "16ui",
	  "scale": "linear",
	  "domain": {
	    "min": 0,
	    "max": 250
	  },
	  "init": {
	    "min": 0,
	    "max": 250
	  },
	  "color_stops": [],
	  "clamp": false,
	  "precision": 0,
	  "factor": 1
	}'
	, vectors jsonb default '{
	  "shape_type": null,
	  "fill": null,
	  "stroke": null,
	  "width": 1,
	  "opacity": 1,
	  "dasharray": "1"
	}'
	, metadata jsonb
	, configuration jsonb
	);

create trigger insert_uuid
	before insert on categories
	for each row
	execute procedure insert_uuid();
