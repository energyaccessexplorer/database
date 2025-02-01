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
