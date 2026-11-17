-- Supabase platform prerequisites, shared by the real supabase-platform
-- bootstrap (root flake) and the CI auth stub. Mirrors
-- supabase/postgres migrations/db/init-scripts, reduced to what GoTrue and
-- Storage migrations assume: the API roles, the auth/extensions/storage
-- schemas and their owners, and the default privileges on public. Loaded into
-- local and scratch databases only, never pushed. Idempotent.

do $$
begin
	if not exists (select from pg_roles where rolname = 'postgres') then
		create role postgres superuser login;
	end if;
	if not exists (select from pg_roles where rolname = 'supabase_admin') then
		create role supabase_admin superuser createdb createrole replication bypassrls login;
	end if;
	if not exists (select from pg_roles where rolname = 'supabase_auth_admin') then
		create role supabase_auth_admin noinherit createrole login noreplication;
	end if;
	if not exists (select from pg_roles where rolname = 'supabase_storage_admin') then
		create role supabase_storage_admin noinherit createrole login noreplication;
	end if;
	if not exists (select from pg_roles where rolname = 'anon') then
		create role anon nologin noinherit;
	end if;
	if not exists (select from pg_roles where rolname = 'authenticated') then
		create role authenticated nologin noinherit;
	end if;
	if not exists (select from pg_roles where rolname = 'service_role') then
		create role service_role nologin noinherit bypassrls;
	end if;
	if not exists (select from pg_roles where rolname = 'authenticator') then
		create role authenticator login noinherit;
	end if;
end $$;

grant anon, authenticated, service_role to authenticator;

create schema if not exists extensions authorization postgres;
create schema if not exists auth authorization supabase_admin;
create schema if not exists storage authorization supabase_admin;

grant usage on schema public to anon, authenticated, service_role;
grant usage on schema extensions to anon, authenticated, service_role;
grant usage on schema auth to anon, authenticated, service_role;
grant usage on schema storage to postgres, anon, authenticated, service_role;

-- GoTrue's migrations run as supabase_auth_admin and own the auth schema.
grant all on schema auth to supabase_auth_admin;
alter user supabase_auth_admin set search_path = "auth";

-- Storage's migrations run as supabase_storage_admin and own the storage schema.
grant all on schema storage to supabase_storage_admin with grant option;
alter user supabase_storage_admin set search_path = "storage";
-- Storage runs each request under the JWT's role with SET ROLE.
grant anon, authenticated, service_role to supabase_storage_admin;
do $$
begin
	execute 'grant create on database ' || current_database() || ' to supabase_storage_admin';
end $$;

alter default privileges in schema storage grant all on tables to postgres, anon, authenticated, service_role;
alter default privileges in schema storage grant all on functions to postgres, anon, authenticated, service_role;
alter default privileges in schema storage grant all on sequences to postgres, anon, authenticated, service_role;

alter default privileges for role postgres in schema public grant all on tables to anon, authenticated, service_role;
alter default privileges for role postgres in schema public grant all on functions to anon, authenticated, service_role;
alter default privileges for role postgres in schema public grant all on sequences to anon, authenticated, service_role;

create or replace function extensions.pgrst_ddl_watch() returns event_trigger
	language plpgsql
	as $$
begin
	notify pgrst, 'reload schema';
end $$;

do $$
begin
	if not exists (select from pg_event_trigger where evtname = 'pgrst_ddl_watch') then
		create event trigger pgrst_ddl_watch on ddl_command_end
			execute procedure extensions.pgrst_ddl_watch();
	end if;
	if not exists (select from pg_event_trigger where evtname = 'pgrst_drop_watch') then
		create event trigger pgrst_drop_watch on sql_drop
			execute procedure extensions.pgrst_ddl_watch();
	end if;
end $$;
