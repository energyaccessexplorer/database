create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

create schema private;
grant usage on schema private to public;

create domain epiphet as name check (value ~ '^[a-z][a-z0-9\-]+$');

create type environments as enum ('test', 'staging', 'production', 'training', 'dev');
-- select enum_range(null::environments);

create function public.current_user_id()
returns uuid
language sql security definer
as $$
	select current_setting('user.id', true)::uuid;
$$;

create function public.current_user_role()
returns text
language sql security definer
as $$
	select current_setting('user.role', true)::text;
$$;

create function public.current_user_email()
returns text
language sql security definer
as $$
	select current_setting('user.email', true)::text;
$$;

create function public.current_user_data(text)
returns jsonb
language sql security definer
as $$
	select current_setting('user.data', true)::jsonb->$1;
$$;

create table events_queue (message jsonb);

create function event_create(trgr text, payload jsonb)
returns jsonb as $$
declare
	message jsonb;

begin
	message = jsonb_build_object(
		'id', current_timestamp,
		'trigger', trgr,
		'payload', payload
	);

	insert into events_queue (message) values (message);

	perform pg_notify('events', message::text);

	return message;
end $$ language plpgsql;

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
	new.created_by = current_user_email();

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
	new.updated_by = current_user_email();

	return new;
end $$;

create function circle_check(circlename epiphet)
returns boolean as $$
	select current_user_data('circles') ? circlename;
$$ language sql immutable;

create function envs_check(envs environments[])
returns boolean as $$
	select current_user_data('envs') ?| envs::text[];
$$ language sql immutable;
