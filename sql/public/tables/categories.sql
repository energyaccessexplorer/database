create table "public"."categories" (
  "id" uuid not null default gen_random_uuid(),
  constraint "categories_pkey" primary key (id)
);

alter table "public"."categories"
  enable row level security;

alter table "public"."categories"
  add column "name" public.epiphet not null;

alter table "public"."categories"
  add column "name_long" character varying(64) not null;

alter table "public"."categories"
  add column "unit" character varying(32);

alter table "public"."categories"
  add column "domain" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "domain_init" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "colorstops" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "raster" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "vectors" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "csv" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "analysis" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "timeline" jsonb default 'null'::jsonb;

alter table "public"."categories"
  add column "mutant" boolean default false;

alter table "public"."categories"
  add column "controls" jsonb default
    jsonb_build_object('range', null::unknown, 'range_steps', null::unknown, 'range_label', null::unknown, 'path', ARRAY[]::text[], 'path_translations', '[]'::jsonb, 'weight',
    false);

alter table "public"."categories"
  add column "description" text;

alter table "public"."categories"
  add column "created" date default CURRENT_DATE;

alter table "public"."categories"
  add column "created_by" character varying(64);

alter table "public"."categories"
  add column "updated" timestamp with time zone default current_timestamp;

alter table "public"."categories"
  add column "updated_by" character varying(64);

alter table "public"."categories"
  add column "name_long_translations" jsonb;

alter table "public"."categories"
  add column "description_translations" jsonb;

alter table "public"."categories"
  add constraint "categories_name_key" unique (name);

create trigger categories_before_create
  before insert on public.categories
  for each row
  execute function private.before_any_create();

create trigger categories_before_update
  before update on public.categories
  for each row
  execute function private.before_any_update();

create policy "public" on "public"."categories"
  for select
  to PUBLIC
  using (true);

create policy "superusers" on "public"."categories"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."categories" to "anon", "authenticated";

revoke all on table "public"."categories" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."categories" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."categories" to "service_role";
