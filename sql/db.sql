create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt
create extension uri;       -- https://github.com/petere/pguri

create role ea_admin;
create role guest nologin;

create function insert_uuid()
returns trigger
language plpgsql as $$ begin
	new.id = gen_random_uuid();
	return new;
end $$;
