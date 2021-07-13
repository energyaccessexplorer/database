create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

-- create role guest nologin;
-- create role root nologin;
-- create role master nologin;
-- create role admin nologin;
-- create role adminguest nologin;

create domain epiphet as name check (value ~ '^[a-z][a-z0-9\-]+$');

create type environments as enum ('test', 'staging', 'production');
-- select enum_range(null::environments);

create function flagged()
returns trigger
language plpgsql immutable as $$ begin
	if (new.flagged and array_position(new.deployment, 'production') > -1) then
		new.deployment = array_remove(new.deployment, 'production');
		raise notice 'Flagged row. Removed "production" from deployment.';
	end if;

	return new;
end $$;

create function before_any_create()
returns trigger
language plpgsql immutable as $$ begin
	new.created = current_timestamp;
	new.created_by = current_setting('request.jwt.claim.email', true);

	return new;
end $$;

create or replace function before_any_update()
returns trigger
language plpgsql immutable as $$ begin
	if (old.updated_by != new.updated_by) or
		(old.created_by != new.created_by) or
		(old.updated != new.updated) or
		(old.created != new.created)
	then
		raise exception 'Columns "updated", "updated_by", "created" and "created_by" are not editable';
	end if;

	new.updated = current_timestamp;
	new.updated_by = current_setting('request.jwt.claim.email', true);

	return new;
end $$;

create function admin_circle(epiphet)
returns boolean as $$
	select ((current_role in ('admin')) and current_setting('request.jwt.claim.data', true)::jsonb->'circles' ? $1);
$$ language sql immutable;

create function guest_circle(epiphet)
returns boolean as $$
	select ((current_role in ('guest')) and current_setting('request.jwt.claim.data', true)::jsonb->'circles' ? $1);
$$ language sql immutable;
