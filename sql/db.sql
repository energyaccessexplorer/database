create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

create role ea_admin;
create role guest nologin;

create function insert_uuid()
returns trigger
language plpgsql as $$ begin
	new.id = gen_random_uuid();
	return new;
end $$;
