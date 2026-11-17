-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
SET LOCAL check_function_bodies = off;
CREATE SCHEMA "authenticator";
CREATE SCHEMA "private";
CREATE SCHEMA "rls";
CREATE TABLE "private"."events_queue" ("message" jsonb);
ALTER TABLE "private"."events_queue" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."access" ("user_id" uuid NOT NULL);
ALTER TABLE "public"."access" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."categories" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), CONSTRAINT "categories_pkey" PRIMARY KEY (id));
ALTER TABLE "public"."categories" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."datasets_permissions" ("user_id" uuid NOT NULL);
ALTER TABLE "public"."datasets_permissions" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."datasets" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "category_id" uuid NOT NULL, "geography_id" uuid NOT NULL, CONSTRAINT "datasets_pkey" PRIMARY KEY (id));
ALTER TABLE "public"."datasets" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."follows" ("email" text, "dataset_id" uuid NOT NULL, "created" date DEFAULT CURRENT_DATE, "created_by" character varying(64), "user_id" uuid NOT NULL, CONSTRAINT "follows_user_id_dataset_id_key" UNIQUE (user_id, dataset_id));
ALTER TABLE "public"."follows" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."geographies" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" character varying(64), "adm" integer, "envelope" double precision[] DEFAULT ARRAY[]::double precision[], "resolution" integer DEFAULT 1000, "parent_id" uuid, "configuration" jsonb DEFAULT jsonb_build_object('boundaries_name', NULL::unknown, 'timeline', false, 'timeline_dates', NULL::unknown, 'flag', NULL::unknown, 'sort_branches', ARRAY[]::text[], 'sort_subbranches', ARRAY[]::text[], 'sort_datasets', ARRAY[]::text[]), CONSTRAINT "geographies_envelope_check" CHECK (((envelope[1] >= ('-180'::integer)::double precision) AND (envelope[3] <= (180)::double precision) AND (envelope[1] < envelope[3]) AND (envelope[2] >= ('-90'::integer)::double precision) AND (envelope[4] <= (90)::double precision) AND (envelope[2] < envelope[4]))), CONSTRAINT "geographies_pkey" PRIMARY KEY (id));
ALTER TABLE "public"."geographies" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."snapshots" ("time" bigint, "config" jsonb, "title" text);
ALTER TABLE "public"."snapshots" ENABLE ROW LEVEL SECURITY;
CREATE TABLE "public"."users" ("email" text NOT NULL, "about" jsonb DEFAULT '{}'::jsonb, "id" uuid NOT NULL DEFAULT gen_random_uuid(), "rwid" text, "disabled" boolean DEFAULT false, CONSTRAINT "users_email_check" CHECK ((email ~ '^[a-zA-Z0-9\''.+_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)), CONSTRAINT "users_email_key" UNIQUE (email), CONSTRAINT "users_pkey" PRIMARY KEY (id), CONSTRAINT "users_rwid_check" CHECK ((rwid ~ '^[0-9a-f]{24}$'::text)), CONSTRAINT "users_rwid_key" UNIQUE (rwid));
ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;
CREATE DOMAIN "public"."epiphet" AS name CONSTRAINT "epiphet_check" CHECK ((VALUE ~ '^[a-z][a-z0-9\-]+$'::text));
ALTER TABLE "public"."access" ADD COLUMN "circle" public.epiphet NOT NULL;
ALTER TABLE "public"."categories" ADD COLUMN "name" public.epiphet NOT NULL;
ALTER TABLE "public"."categories" ADD COLUMN "name_long" character varying(64) NOT NULL;
ALTER TABLE "public"."categories" ADD COLUMN "unit" character varying(32);
ALTER TABLE "public"."categories" ADD COLUMN "domain" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "domain_init" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "colorstops" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "raster" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "vectors" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "csv" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "analysis" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "timeline" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "mutant" boolean DEFAULT false;
ALTER TABLE "public"."categories" ADD COLUMN "controls" jsonb DEFAULT jsonb_build_object('range', NULL::unknown, 'range_steps', NULL::unknown, 'range_label', NULL::unknown, 'path', ARRAY[]::text[], 'path_translations', '[]'::jsonb, 'weight', false);
ALTER TABLE "public"."categories" ADD COLUMN "description" text;
ALTER TABLE "public"."categories" ADD COLUMN "created" date DEFAULT CURRENT_DATE;
ALTER TABLE "public"."categories" ADD COLUMN "created_by" character varying(64);
ALTER TABLE "public"."categories" ADD COLUMN "updated" timestamp with time zone DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE "public"."categories" ADD COLUMN "updated_by" character varying(64);
ALTER TABLE "public"."categories" ADD COLUMN "name_long_translations" jsonb;
ALTER TABLE "public"."categories" ADD COLUMN "description_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "name" public.epiphet DEFAULT NULL::name;
ALTER TABLE "public"."datasets" ADD COLUMN "name_long" text;
CREATE TYPE "public"."environments" AS ENUM ('test', 'protected', 'public', 'training', 'dev');
ALTER TABLE "public"."access" ADD COLUMN "deployment" public.environments NOT NULL;
ALTER TABLE "public"."datasets" ADD COLUMN "deployment" public.environments[] DEFAULT ARRAY[]::public.environments[];
ALTER TABLE "public"."datasets" ADD COLUMN "flagged" boolean DEFAULT false;
ALTER TABLE "public"."datasets" ADD COLUMN "vectors_configuration" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "category_overrides" jsonb DEFAULT 'null'::jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "source_files" jsonb DEFAULT '[]'::jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "processed_files" jsonb DEFAULT '[]'::jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "metadata" jsonb DEFAULT jsonb_build_object('description', NULL::unknown, 'suggested_citation', NULL::unknown, 'cautions', NULL::unknown, 'spatial_resolution', NULL::unknown, 'license', NULL::unknown, 'sources', NULL::unknown, 'content_date', NULL::unknown, 'download_original_url', NULL::unknown, 'learn_more_url', NULL::unknown);
ALTER TABLE "public"."datasets" ADD COLUMN "created" date DEFAULT CURRENT_DATE;
ALTER TABLE "public"."datasets" ADD COLUMN "created_by" character varying(64);
ALTER TABLE "public"."datasets" ADD COLUMN "updated" timestamp with time zone DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE "public"."datasets" ADD COLUMN "updated_by" character varying(64);
ALTER TABLE "public"."datasets" ADD COLUMN "notification_interval" text;
ALTER TABLE "public"."datasets" ADD COLUMN "notification_latest" date;
ALTER TABLE "public"."datasets" ADD COLUMN "mutant_configuration" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "private" boolean DEFAULT false;
ALTER TABLE "public"."datasets" ADD COLUMN "name_long_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "description_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "cautions_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "license_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "sources_translations" jsonb;
ALTER TABLE "public"."datasets" ADD COLUMN "suggested_citation_translations" jsonb;
ALTER TABLE "public"."geographies" ADD COLUMN "deployment" public.environments[] DEFAULT ARRAY[]::public.environments[];
ALTER TABLE "public"."geographies" ADD COLUMN "flagged" boolean DEFAULT false;
ALTER TABLE "public"."geographies" ADD COLUMN "created" date DEFAULT CURRENT_DATE;
ALTER TABLE "public"."geographies" ADD COLUMN "created_by" character varying(64);
ALTER TABLE "public"."geographies" ADD COLUMN "updated" timestamp with time zone DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE "public"."geographies" ADD COLUMN "updated_by" character varying(64);
ALTER TABLE "public"."geographies" ADD COLUMN "area" bigint;
ALTER TABLE "public"."geographies" ADD COLUMN "circles" public.epiphet[] DEFAULT ARRAY[]::public.epiphet[];
ALTER TABLE "public"."snapshots" ADD COLUMN "env" public.environments NOT NULL;
ALTER TABLE "public"."snapshots" ADD COLUMN "user_id" uuid NOT NULL;
ALTER TABLE "public"."snapshots" ADD COLUMN "geography_id" uuid NOT NULL;
CREATE TYPE "public"."permission_types" AS ENUM ('read', 'write', 'publish');
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "type" public.permission_types NOT NULL;
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "dataset_id" uuid NOT NULL;
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "created" date DEFAULT CURRENT_DATE;
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "created_by" character varying(64);
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "updated" timestamp with time zone DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE "public"."datasets_permissions" ADD COLUMN "updated_by" character varying(64);
CREATE TYPE "public"."roles" AS ENUM ('guest', 'guest-admin', 'admin', 'leader', 'manager', 'director', 'root');
ALTER TABLE "public"."users" ADD COLUMN "role" public.roles DEFAULT 'guest'::public.roles;
CREATE OR REPLACE FUNCTION authenticator.check_check()
 RETURNS json
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
	setting text := current_setting('app.settings.authenticator_psk')::text;
	header text := (current_setting('request.headers', true)::json->>'x-authenticator-psk')::text;
begin
	if (header = setting) then
		return json_build_object(
			'status', 'OK'
		);
	end if;

	perform set_config('response.status', '401', true);

	return json_build_object(
		'message', 'wrong x-authenticator-psk headers',
		'hint', 'provided header: ' || coalesce(header, '<none>')
	);
end $function$;
CREATE OR REPLACE FUNCTION authenticator.user_upsert(json)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_catalog'
AS $function$
declare
	_id uuid;
	_email text;
	_rwid text;
	_about jsonb;
begin
	if (current_setting('request.headers', true)::json->>'x-authenticator-psk' = current_setting('app.settings.authenticator_psk')) then
		update users u set email = $1->>'email' where rwid = $1->>'rwid';

		insert into users as u (email, rwid, about)
			values ($1->>'email', $1->>'rwid', $1->'about')
			on conflict (email) do update set
				email = coalesce($1->>'email', u.email),
				rwid = coalesce($1->>'rwid', u.rwid),
				about = coalesce(($1->>'about')::jsonb, u.about::jsonb)
			returning id, email, rwid, about into _id, _email, _rwid, _about;

		perform set_config('response.status', '200', true);
		return json_build_object('id', _id, 'email', _email, 'rwid', _rwid, 'about', _about);
	end if;

	perform set_config('response.status', '401', true);
	return json_build_object(
		'message', 'Wrong authentication headers',
		'hint', 'Check ''em'
	);
end $function$;
CREATE OR REPLACE FUNCTION private.before_any_create()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	new.created = current_timestamp;
	new.created_by = current_user_email();

	return new;
end $function$;
CREATE OR REPLACE FUNCTION private.before_any_update()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
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
end $function$;
CREATE OR REPLACE FUNCTION private.datasets_flagged()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	if (not old.flagged and new.flagged) then
		perform event_create('dataset:flagged', jsonb_build_object(
			'id', new.id,
			'last_updated_by', old.updated_by
		));
	end if;

	return new;
end $function$;
CREATE OR REPLACE FUNCTION private.datasets_publish()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
declare
	added environments[];
	removed environments[];
	allowed environments[];
begin
	if current_user_role() > 'manager'::roles then
		return new;
	end if;

    if true and
        new.deployment @> old.deployment and
        new.deployment <@ old.deployment then
        return new;
    end if;

	select array_agg(x) from unnest(new.deployment) x where x not in (select unnest(old.deployment)) into added;
	select array_agg(x) from unnest(old.deployment) x where x not in (select unnest(new.deployment)) into removed;

	select array_agg(deployment) from access a
	where a.user_id = current_user_id()
		and a.circle = ANY (circles(new))
	into allowed;

	if ((added <@ allowed) and (removed <@ allowed)) then
		return new;
	end if;

	if (not added <@ allowed) then
		raise exception 'You cannot add access you do not belong to yourself (added %), (allowed %)', added, allowed;
	end if;

	if (not removed <@ allowed) then
		raise exception 'You cannot remove access you do not belong to yourself (removed %), (allowed %)', removed, allowed;
	end if;

    return new;
end $function$;
CREATE OR REPLACE FUNCTION private.delete_self()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
begin
	raise 'Cannot delete yourself! Ask someone else to do it.';
end $function$;
CREATE OR REPLACE FUNCTION private.email_change_fail()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
begin
	raise exception 'You cannot change emails here.';
end $function$;
CREATE OR REPLACE FUNCTION private.event_create(trgr text, payload jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
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
end $function$;
CREATE OR REPLACE FUNCTION private.flagged()
 RETURNS trigger
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	if (new.flagged and array_position(new.deployment, 'public') > -1) then
		new.deployment = array_remove(new.deployment, 'public');
		raise notice 'Flagged row. Removed "public" from deployment.';
	end if;

	return new;
end $function$;
CREATE OR REPLACE FUNCTION private.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	insert into public.users (id, email)
		values (new.id, new.email)
		on conflict (id) do update set
			email = excluded.email;

	return new;
end $function$;
CREATE OR REPLACE FUNCTION private.handle_user_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	update public.users set email = new.email where id = new.id;

	return new;
end $function$;
CREATE OR REPLACE FUNCTION private.upgrade_fail()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
begin
	raise exception 'You cannot upgrade roles above you.';
end $function$;
CREATE OR REPLACE FUNCTION private.user_credentials()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'pg_catalog'
AS $function$
declare
	zero text := '00000000-0000-0000-0000-000000000000';
	_id  text := current_setting('request.jwt.claims', true)::jsonb->>'id';
	u users;
begin
	if _id is null then
		perform set_config('user.id',    zero,   true);
		perform set_config('user.email', null,   true);
		perform set_config('user.role', 'guest', true);
		return;
	end if;

	if _id ~ '^[0-9a-f]{24}$' then
		select * from users where rwid = _id into u;
	else
		select * from users where id = _id::uuid into u;
	end if;

	if u is null and then
		raise exception 'Unknown credentials';
	end if;

	if u.disabled then
		raise exception 'User disabled';
	end if;

	perform set_config('user.id',    u.id::text,    true);
	perform set_config('user.email', u.email::text, true);
	perform set_config('user.role',  u.role::text,  true);
end
$function$;
CREATE OR REPLACE FUNCTION public.category_datatype(c public.categories)
 RETURNS public.epiphet
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
declare
	x epiphet;
	y epiphet;
begin
	if (c.name in ('outline', 'boundaries')) then
		return 'polygons-boundaries';
	end if;

	select (case
	when (c.vectors <> 'null') then
		c.vectors->>'shape_type'
	when (c.raster <> 'null') then
		'raster'
	when (c.csv <> 'null') then
		'table'
	when (c.mutant) then
		'mutant'
	else
		null
	end) into x;

	select (case
	when (c.timeline <> 'null') then
		'timeline'
	when (x <> 'table' and c.csv <> 'null') then
		'valued'
	else
		null
	end) into y;

	return x || coalesce('-' || y, '');
end
$function$;
CREATE OR REPLACE FUNCTION public.category_name(public.datasets)
 RETURNS public.epiphet
 LANGUAGE sql
 STABLE
AS $function$
	select name from categories where id = $1.category_id;
$function$;
CREATE OR REPLACE FUNCTION public.circles(public.datasets)
 RETURNS public.epiphet[]
 LANGUAGE sql
 STABLE
AS $function$
        select circles from public.geographies where id = $1.geography_id;
$function$;
CREATE OR REPLACE FUNCTION public.dataset_info(public.follows)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
	select info(d) from datasets d where id = $1.dataset_id;
$function$;
CREATE OR REPLACE FUNCTION public.datasets_count(public.geographies)
 RETURNS bigint
 LANGUAGE sql
 STABLE
AS $function$
	select count(1) from datasets where geography_id = $1.id;
$function$;
CREATE OR REPLACE FUNCTION public.datatype(c public.categories)
 RETURNS public.epiphet
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
declare
	x epiphet;
	y epiphet;
begin
	if (c.name in ('outline', 'boundaries')) then
		return 'polygons-boundaries';
	end if;

	select (case
	when (c.vectors <> 'null') then
		c.vectors->>'shape_type'
	when (c.raster <> 'null') then
		'raster'
	when (c.csv <> 'null') then
		'table'
	when (c.mutant) then
		'mutant'
	else
		null
	end) into x;

	select (case
	when (c.timeline <> 'null') then
		'timeline'
	when (x <> 'table' and c.csv <> 'null') then
		'valued'
	else
		null
	end) into y;

	return x || coalesce('-' || y, '');
end
$function$;
CREATE OR REPLACE FUNCTION public.geography_name(public.datasets)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
	select name from geographies where id = $1.geography_id;
$function$;
CREATE OR REPLACE FUNCTION public.has_subgeographies(public.geographies)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
	select coalesce((select true from geographies where parent_id = $1.id limit 1), false);
$function$;
CREATE OR REPLACE FUNCTION public.info(public.datasets)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
	select geography_name($1) || ' - ' || category_name($1);
$function$;
CREATE OR REPLACE FUNCTION public.parent_configuration(character varying)
 RETURNS TABLE(id uuid, obj jsonb)
 LANGUAGE sql
 STABLE
AS $function$
	with recursive r as (
		select
			g.id,
			g.parent_id,
			nullif(g.configuration->$1, 'null') as obj
		from geographies g

	union
		select
			g.id,
			g.parent_id,
			coalesce(nullif(g.configuration->$1, 'null'), r.obj)
		from geographies g
		inner join r on r.id = g.parent_id

	) select id, obj from r where obj is not null;
$function$;
CREATE OR REPLACE FUNCTION public.parent_sort_branches(public.geographies)
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
	select obj from parent_configuration('sort_branches') t where t.id = $1.id;
$function$;
CREATE OR REPLACE FUNCTION public.parent_sort_datasets(public.geographies)
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
	select obj from parent_configuration('sort_datasets') t where t.id = $1.id;
$function$;
CREATE OR REPLACE FUNCTION public.parent_sort_subbranches(public.geographies)
 RETURNS jsonb
 LANGUAGE sql
 STABLE
AS $function$
	select obj from parent_configuration('sort_subbranches') t where t.id = $1.id;
$function$;
CREATE OR REPLACE FUNCTION public.snapshot(_time bigint)
 RETURNS TABLE("time" bigint, config jsonb, geography_id uuid, user_id uuid, title text)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'pg_catalog'
AS $function$
	select
		"time",
		config,
		geography_id,
		user_id,
		title
	from snapshots x
		where x."time" = _time;
$function$;
CREATE OR REPLACE FUNCTION public.type(public.datasets)
 RETURNS public.epiphet
 LANGUAGE plpgsql
 STABLE
AS $function$
declare
	c categories;
	x epiphet;
begin
	select * from categories where id = $1.category_id into c;

	if (not c.mutant) then
		return category_datatype(c);
	end if;

	select d.type from datasets d
		where ($1.mutant_configuration -> 'hosts' ->> 0) = any(array[d.category_name, d.name])
		and d.geography_id = $1.geography_id into x;

	return coalesce(x || '-', '') || 'mutant';
end
$function$;
CREATE OR REPLACE FUNCTION public.with_access(public.geographies)
 RETURNS boolean
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select exists (
		select 1 from access a
			where user_id = current_user_id()
			and circle = ANY ($1.circles)
	)
$function$;
CREATE OR REPLACE FUNCTION rls.access_access(uid uuid, cir name, dep public.environments)
 RETURNS boolean
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select exists (
		select 1 from access
		where user_id = uid
			and circle = cir
			and deployment = dep
	)
$function$;
CREATE OR REPLACE FUNCTION rls.access_check(uid uuid, cir public.epiphet[], dep public.environments[])
 RETURNS boolean
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (cir)
			and ((cardinality(dep) = 0) -- new/unpopulated
				 or a.deployment = ANY (dep))
	);
$function$;
CREATE OR REPLACE FUNCTION rls.current_user_data(text)
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select about -> $1 from public.users where id = auth.uid();
$function$;
CREATE OR REPLACE FUNCTION rls.current_user_email()
 RETURNS text
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select auth.jwt()->>'email';
$function$;
CREATE OR REPLACE FUNCTION rls.current_user_id()
 RETURNS uuid
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select auth.uid();
$function$;
CREATE OR REPLACE FUNCTION rls.current_user_role()
 RETURNS public.roles
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select coalesce(
		(select role from public.users where id = auth.uid()),
		'guest'::public.roles
	);
$function$;
CREATE OR REPLACE FUNCTION rls.datasets_allowed(did uuid, typ public.permission_types)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
select exists (
    select 1 from datasets_permissions where
        user_id = current_user_id()
        and dataset_id = did
        and "type" = typ
)
$function$;
CREATE OR REPLACE FUNCTION rls.datasets_permissions_check(uid uuid, did uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
declare
	g geographies;
	d datasets;
begin
	select * from datasets where id = did into d;
	select * from geographies where id = d.geography_id into g;

 	return exists (
		select 1 from access as a
		where a.user_id = uid
			and a.circle = ANY (g.circles)
			and a.deployment = ANY (g.deployment)
	);
end $function$;
CREATE OR REPLACE FUNCTION rls.users_access(uid uuid, cid uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$
	select exists (
		select 1 from access
		where (circle, deployment) in (select circle, deployment from access where user_id = uid)
		and user_id = cid
	)
$function$;
ALTER TABLE "public"."access" ADD CONSTRAINT "access_pkey" PRIMARY KEY (user_id, circle, deployment);
ALTER TABLE "public"."categories" ADD CONSTRAINT "categories_name_key" UNIQUE (name);
ALTER TABLE "public"."datasets" ADD CONSTRAINT "category" FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;
ALTER TABLE "public"."datasets" ADD CONSTRAINT "datasets_geography_id_name_key" UNIQUE (geography_id, name);
ALTER TABLE "public"."datasets" ADD CONSTRAINT "datasets_geography_id_name_long_key" UNIQUE (geography_id, name_long);
ALTER TABLE "public"."datasets" ADD CONSTRAINT "datasets_notification_interval_check" CHECK ((notification_interval ~ '^[0-9]{1,2} (day|week|month|year)s?$'::text));
ALTER TABLE "public"."datasets_permissions" ADD CONSTRAINT "datasets_permissions_user_id_dataset_id_key" UNIQUE (user_id, dataset_id);
ALTER TABLE "public"."datasets_permissions" ADD CONSTRAINT "dataset" FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_dataset_id_fkey" FOREIGN KEY (dataset_id) REFERENCES public.datasets(id) ON DELETE CASCADE;
ALTER TABLE "public"."datasets" ADD CONSTRAINT "geography" FOREIGN KEY (geography_id) REFERENCES public.geographies(id) ON DELETE CASCADE;
ALTER TABLE "public"."geographies" ADD CONSTRAINT "parent" FOREIGN KEY (parent_id) REFERENCES public.geographies(id);
ALTER TABLE "public"."snapshots" ADD CONSTRAINT "snapshots_geography_id_fkey" FOREIGN KEY (geography_id) REFERENCES public.geographies(id);
ALTER TABLE "public"."access" ADD CONSTRAINT "user" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE "public"."datasets_permissions" ADD CONSTRAINT "user" FOREIGN KEY (user_id) REFERENCES public.users(id);
ALTER TABLE "public"."follows" ADD CONSTRAINT "follows_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE "public"."snapshots" ADD CONSTRAINT "snapshots_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id);
CREATE VIEW "public"."geographies_tree_down" AS  WITH RECURSIVE tree AS (
         SELECT geographies.id,
            geographies.parent_id,
            ARRAY[geographies.id] AS path
           FROM public.geographies
        UNION ALL
         SELECT c.id,
            c.parent_id,
            array_prepend(c.id, t.path) AS array_prepend
           FROM (public.geographies c
             JOIN tree t ON ((c.id = t.parent_id)))
        )
 SELECT id,
    path
   FROM tree
  ORDER BY (array_length(path, 1));
CREATE VIEW "public"."geographies_tree_up" AS  WITH RECURSIVE tree AS (
         SELECT geographies.id,
            geographies.parent_id,
            ARRAY[geographies.id] AS path
           FROM public.geographies
          WHERE (geographies.parent_id IS NULL)
        UNION ALL
         SELECT c.id,
            c.parent_id,
            array_append(t.path, c.id) AS array_append
           FROM (public.geographies c
             JOIN tree t ON ((t.id = c.parent_id)))
        )
 SELECT id,
    path
   FROM tree;
CREATE INDEX access_user_circle_deployment_idx ON public.access USING btree (user_id, circle, deployment);
CREATE INDEX access_user_id_idx ON public.access USING btree (user_id);
CREATE INDEX datasets_category_id_idx ON public.datasets USING btree (category_id);
CREATE INDEX datasets_permissions_dataset_id_idx ON public.datasets_permissions USING btree (dataset_id);
CREATE INDEX follows_dataset_id_idx ON public.follows USING btree (dataset_id);
CREATE INDEX geographies_parent_id_idx ON public.geographies USING btree (parent_id);
CREATE INDEX snapshots_geography_id_idx ON public.snapshots USING btree (geography_id);
CREATE INDEX snapshots_user_id_idx ON public.snapshots USING btree (user_id);
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION private.handle_new_user();
CREATE TRIGGER on_auth_user_updated AFTER UPDATE OF email, email_confirmed_at ON auth.users FOR EACH ROW EXECUTE FUNCTION private.handle_user_update();
CREATE TRIGGER categories_before_create BEFORE INSERT ON public.categories FOR EACH ROW EXECUTE FUNCTION private.before_any_create();
CREATE TRIGGER categories_before_update BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION private.before_any_update();
CREATE TRIGGER datasets_before_create BEFORE INSERT ON public.datasets FOR EACH ROW EXECUTE FUNCTION private.before_any_create();
CREATE TRIGGER datasets_before_update BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION private.before_any_update();
CREATE TRIGGER datasets_flagged_notify BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION private.datasets_flagged();
CREATE TRIGGER datasets_flagged BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION private.flagged();
CREATE TRIGGER datasets_publish BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION private.datasets_publish();
CREATE TRIGGER follows_before_create BEFORE INSERT ON public.follows FOR EACH ROW EXECUTE FUNCTION private.before_any_create();
CREATE TRIGGER geographies_before_create BEFORE INSERT ON public.geographies FOR EACH ROW EXECUTE FUNCTION private.before_any_create();
CREATE TRIGGER geographies_before_update BEFORE UPDATE ON public.geographies FOR EACH ROW EXECUTE FUNCTION private.before_any_update();
CREATE TRIGGER geographies_flagged BEFORE UPDATE ON public.geographies FOR EACH ROW EXECUTE FUNCTION private.flagged();
CREATE TRIGGER delete_self BEFORE DELETE ON public.users FOR EACH ROW WHEN ((old.id = rls.current_user_id())) EXECUTE FUNCTION private.delete_self();
CREATE TRIGGER email_change_check BEFORE UPDATE ON public.users FOR EACH ROW WHEN ((new.email <> old.email)) EXECUTE FUNCTION private.email_change_fail();
CREATE TRIGGER upgrade_check_insert BEFORE INSERT ON public.users FOR EACH ROW WHEN ((new.role > rls.current_user_role())) EXECUTE FUNCTION private.upgrade_fail();
CREATE TRIGGER upgrade_check_update BEFORE UPDATE ON public.users FOR EACH ROW WHEN (((new.role IS DISTINCT FROM old.role) AND (new.role > rls.current_user_role()))) EXECUTE FUNCTION private.upgrade_fail();
CREATE POLICY "insert_only" ON "private"."events_queue" FOR INSERT TO "authenticated", "service_role" WITH CHECK (true);
CREATE POLICY "manager" ON "public"."access" FOR ALL TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND rls.access_access(rls.current_user_id(), (circle)::name, deployment)));
CREATE POLICY "superusers" ON "public"."access" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "user" ON "public"."access" FOR SELECT TO PUBLIC USING ((user_id = rls.current_user_id()));
CREATE POLICY "public" ON "public"."categories" FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "superusers" ON "public"."categories" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "access_check_admin" ON "public"."datasets" FOR ALL TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND (NOT private) AND rls.access_check(rls.current_user_id(), public.circles(datasets.*), deployment)));
CREATE POLICY "access_check_guest" ON "public"."datasets" FOR SELECT TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND (NOT private) AND rls.access_check(rls.current_user_id(), public.circles(datasets.*), deployment)));
CREATE POLICY "public_select" ON "public"."datasets" FOR SELECT TO PUBLIC USING (((NOT flagged) AND (NOT private) AND ('public'::public.environments = ANY (deployment))));
CREATE POLICY "publish_select" ON "public"."datasets" FOR SELECT TO PUBLIC USING ((private AND rls.datasets_allowed(id, 'publish'::public.permission_types)));
CREATE POLICY "publish" ON "public"."datasets" FOR UPDATE TO PUBLIC USING ((private AND rls.datasets_allowed(id, 'publish'::public.permission_types)));
CREATE POLICY "read" ON "public"."datasets" FOR SELECT TO PUBLIC USING ((private AND rls.datasets_allowed(id, 'read'::public.permission_types)));
CREATE POLICY "superusers" ON "public"."datasets" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "write_select" ON "public"."datasets" FOR SELECT TO PUBLIC USING (rls.datasets_allowed(id, 'write'::public.permission_types));
CREATE POLICY "write" ON "public"."datasets" FOR UPDATE TO PUBLIC USING (rls.datasets_allowed(id, 'write'::public.permission_types));
CREATE POLICY "managers" ON "public"."datasets_permissions" FOR ALL TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND rls.datasets_permissions_check(rls.current_user_id(), dataset_id)));
CREATE POLICY "superusers" ON "public"."datasets_permissions" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "user" ON "public"."datasets_permissions" FOR SELECT TO PUBLIC USING ((user_id = rls.current_user_id()));
CREATE POLICY "superusers" ON "public"."follows" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "access_check_admin" ON "public"."geographies" FOR ALL TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND rls.access_check(rls.current_user_id(), circles, deployment)));
CREATE POLICY "access_check_guest" ON "public"."geographies" FOR SELECT TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND rls.access_check(rls.current_user_id(), circles, deployment)));
CREATE POLICY "public_select" ON "public"."geographies" FOR SELECT TO PUBLIC USING (((NOT flagged) AND ('public'::public.environments = ANY (deployment))));
CREATE POLICY "superusers" ON "public"."geographies" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "owner" ON "public"."snapshots" FOR ALL TO PUBLIC USING ((user_id = rls.current_user_id()));
CREATE POLICY "superusers" ON "public"."snapshots" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
CREATE POLICY "manager_other" ON "public"."users" FOR SELECT TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND rls.users_access(rls.current_user_id(), id)));
CREATE POLICY "manager" ON "public"."users" FOR ALL TO PUBLIC USING (((rls.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND (role < rls.current_user_role()) AND rls.users_access(rls.current_user_id(), id)));
CREATE POLICY "self" ON "public"."users" FOR ALL TO PUBLIC USING ((email = rls.current_user_email()));
CREATE POLICY "superusers" ON "public"."users" FOR ALL TO PUBLIC USING ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
REVOKE ALL ON FUNCTION "private"."before_any_create"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."before_any_create"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."before_any_update"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."before_any_update"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."datasets_flagged"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."datasets_flagged"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."datasets_publish"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."datasets_publish"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."delete_self"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."delete_self"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."email_change_fail"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."email_change_fail"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."event_create"(text, jsonb) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."event_create"(text, jsonb) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."flagged"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."flagged"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."handle_new_user"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."handle_new_user"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."handle_user_update"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."handle_user_update"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."upgrade_fail"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "private"."upgrade_fail"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "private"."user_credentials"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "public"."category_datatype"(public.categories) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."category_datatype"(public.categories) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."category_datatype"(public.categories) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."category_datatype"(public.categories) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."category_name"(public.datasets) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."category_name"(public.datasets) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."category_name"(public.datasets) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."category_name"(public.datasets) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."circles"(public.datasets) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."circles"(public.datasets) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."circles"(public.datasets) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."circles"(public.datasets) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."dataset_info"(public.follows) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."dataset_info"(public.follows) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."dataset_info"(public.follows) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."dataset_info"(public.follows) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."datasets_count"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."datasets_count"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."datasets_count"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."datasets_count"(public.geographies) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."datatype"(public.categories) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."datatype"(public.categories) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."datatype"(public.categories) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."datatype"(public.categories) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."geography_name"(public.datasets) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."geography_name"(public.datasets) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."geography_name"(public.datasets) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."geography_name"(public.datasets) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."has_subgeographies"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."has_subgeographies"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."has_subgeographies"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."has_subgeographies"(public.geographies) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."info"(public.datasets) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."info"(public.datasets) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."info"(public.datasets) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."info"(public.datasets) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."parent_configuration"(character varying) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."parent_configuration"(character varying) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_configuration"(character varying) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_configuration"(character varying) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_branches"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."parent_sort_branches"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_branches"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_branches"(public.geographies) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_datasets"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."parent_sort_datasets"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_datasets"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_datasets"(public.geographies) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_subbranches"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."parent_sort_subbranches"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_subbranches"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."parent_sort_subbranches"(public.geographies) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."snapshot"(bigint) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."snapshot"(bigint) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."snapshot"(bigint) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."snapshot"(bigint) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."type"(public.datasets) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."type"(public.datasets) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."type"(public.datasets) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."type"(public.datasets) TO "service_role";
GRANT EXECUTE ON FUNCTION "public"."with_access"(public.geographies) TO PUBLIC, "anon", "authenticated";
REVOKE ALL ON FUNCTION "public"."with_access"(public.geographies) FROM "postgres";
GRANT EXECUTE ON FUNCTION "public"."with_access"(public.geographies) TO "postgres";
GRANT EXECUTE ON FUNCTION "public"."with_access"(public.geographies) TO "service_role";
REVOKE ALL ON FUNCTION "rls"."access_access"(uuid, name, public.environments) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."access_access"(uuid, name, public.environments) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."access_check"(uuid, public.epiphet[], public.environments[]) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."access_check"(uuid, public.epiphet[], public.environments[]) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."current_user_data"(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."current_user_data"(text) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."current_user_email"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."current_user_email"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."current_user_id"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."current_user_id"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."current_user_role"() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."current_user_role"() TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."datasets_allowed"(uuid, public.permission_types) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."datasets_allowed"(uuid, public.permission_types) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."datasets_permissions_check"(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."datasets_permissions_check"(uuid, uuid) TO "anon", "authenticated", "service_role";
REVOKE ALL ON FUNCTION "rls"."users_access"(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION "rls"."users_access"(uuid, uuid) TO "anon", "authenticated", "service_role";
GRANT USAGE ON SCHEMA "private" TO "anon", "authenticated", "service_role";
GRANT USAGE ON SCHEMA "rls" TO "anon", "authenticated", "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "private"."events_queue" TO "anon";
GRANT INSERT, MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "private"."events_queue" TO "authenticated", "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."access" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."access" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."access" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."access" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."categories" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."categories" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."categories" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."categories" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."datasets" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets_permissions" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."datasets_permissions" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets_permissions" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."datasets_permissions" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."follows" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."follows" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."follows" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."follows" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."geographies" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."snapshots" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."snapshots" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."snapshots" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."snapshots" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."users" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_down" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."geographies_tree_down" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_down" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_down" TO "service_role";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_up" TO "anon", "authenticated";
REVOKE ALL ON TABLE "public"."geographies_tree_up" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_up" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."geographies_tree_up" TO "service_role";
COMMIT;
