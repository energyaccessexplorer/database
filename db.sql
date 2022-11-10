create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

create or replace function role_create(text)
returns void as $$
begin
	if not exists(select 1 from pg_roles where rolname=$1) then
		execute format('create role %I nologin', $1);
	else
		raise notice '"%" role already exists.', $1;
	end if;
end
$$ language plpgsql;

select role_create('root');
select role_create('master');
select role_create('manager');
select role_create('leader');
select role_create('admin');
select role_create('adminguest');
select role_create('guest');

drop function role_create(text);

create domain epiphet as name check (value ~ '^[a-z][a-z0-9\-]+$');

create type environments as enum ('test', 'staging', 'production', 'training', 'dev');
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
	new.created_by = regexp_replace(current_setting('request.jwt.claims', true)::jsonb->>'email', '(.*)@.*', '\1');

	return new;
end $$;

create function before_any_update()
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
	new.updated_by = regexp_replace(current_setting('request.jwt.claims', true)::jsonb->>'email', '(.*)@.*', '\1');

	return new;
end $$;

create function circle_check(circlename epiphet)
returns boolean as $$
	select current_setting('request.jwt.claims', true)::jsonb->'data'->'circles' ? circlename;
$$ language sql immutable;

create function envs_check(envs environments[])
returns boolean as $$
	select current_setting('request.jwt.claims', true)::jsonb->'data'->'envs' ?| envs::text[];
$$ language sql immutable;

create function circle_roles_check(circlename epiphet, variadic rolenames name[])
returns boolean as $$
	select (
		circle_check(circlename) and
		(current_role in (select unnest(rolenames)))
	);
$$ language sql immutable;
