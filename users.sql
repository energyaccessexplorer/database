create type users_enum as enum ('guest', 'admin', 'leader', 'manager', 'director', 'root');

create table users (
	  id uuid primary key default gen_random_uuid()
	, email text not null unique
	, check (email ~ '^[a-zA-Z0-9\''.+_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
	, rwid text unique
	, check (rwid ~ '^[0-9a-f]{24}$')
	, data jsonb default '{ "circles": [], "envs": [] }'::jsonb
	, role name default 'guest'
	, check (role in ('root', 'director', 'manager', 'leader', 'admin', 'guest'))
	, about jsonb default '{}'::jsonb
	, disabled boolean default false
);

create or replace function delete_self()
returns trigger
language plpgsql as $$
begin
	raise 'Cannot delete yourself! Ask someone else to do it.';
end $$;

create trigger delete_self
	before delete on users
	for each row
	when (old.id = current_user_id())
	execute procedure delete_self();

create function upgrade_fail()
returns trigger as $$
begin
	raise exception 'You cannot upgrade roles above you.';
end $$ language plpgsql;

create trigger upgrade_check
	before insert or update on users
	for each row
	when (new.role::users_enum > current_user_role()::users_enum)
	execute function upgrade_fail();

create function email_change_fail()
returns trigger as $$
begin
	raise exception 'You cannot change emails here.';
end $$ language plpgsql;

create trigger email_change_check
	before update on users
	for each row
	when (new.email <> old.email)
	execute function email_change_fail();

create function circles_change_check()
returns trigger as $$
declare
	allowed_array text[] := array(select jsonb_array_elements_text(current_user_data('circles')))::text[];
	new_array text[] := array(select json_array_elements_text((new.data->'circles')::json))::text[];
	old_array text[] := array(select json_array_elements_text((old.data->'circles')::json))::text[];

	added text[];
	removed text[];
begin
	if (current_user_role() in ('director', 'root')) then
		return new;
	end if;

	select coalesce(array_agg(x), array[]::text[]) from unnest(new_array) x where x not in (select unnest(old_array)) into added;
	select coalesce(array_agg(x), array[]::text[]) from unnest(old_array) x where x not in (select unnest(new_array)) into removed;

	if ((added <@ allowed_array) and (removed <@ allowed_array)) then
		return new;
	end if;

	if (not added <@ allowed_array) then
		raise exception 'You cannot add users to circles you do not belong to yourself';
	end if;

	if (not removed <@ allowed_array) then
		raise exception 'You cannot remove users from circles you do not belong to yourself';
	end if;
end $$ language plpgsql;

create trigger circles_change_check
	before update on users
	for each row
	when (new.data <> old.data)
	execute function circles_change_check();
