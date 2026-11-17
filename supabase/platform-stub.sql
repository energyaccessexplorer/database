-- Stand-in for the parts of the auth and storage schemas sql/ refers to, used
-- where no real platform command (DB_PLATFORM) runs, e.g. CI. GoTrue's and
-- Storage's own migrations create the real ones. Runs after platform.sql.
-- Idempotent.

create table if not exists auth.users (
	id                 uuid primary key,
	email              character varying(255),
	email_confirmed_at timestamp with time zone,
	raw_user_meta_data jsonb,
	created_at         timestamp with time zone default now(),
	updated_at         timestamp with time zone default now()
);

create or replace function auth.jwt() returns jsonb
	language sql stable
	as $$
	select coalesce(
		nullif(current_setting('request.jwt.claim', true), ''),
		nullif(current_setting('request.jwt.claims', true), '')
	)::jsonb
$$;

create or replace function auth.uid() returns uuid
	language sql stable
	as $$
	select coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$$;

create or replace function auth.role() returns text
	language sql stable
	as $$
	select coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$$;

create or replace function auth.email() returns text
	language sql stable
	as $$
	select coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$$;

create table if not exists storage.buckets (
	id     text primary key,
	name   text not null,
	public boolean default false
);

create table if not exists storage.objects (
	id        uuid primary key default gen_random_uuid(),
	bucket_id text references storage.buckets (id),
	name      text,
	owner     uuid,
	metadata  jsonb
);

alter table storage.objects enable row level security;
