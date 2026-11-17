create table "public"."datasets" (
  "id"           uuid not null default gen_random_uuid(),
  "category_id"  uuid not null,
  "geography_id" uuid not null,
  constraint "category" foreign key (category_id) references public.categories(id) on delete cascade,
  constraint "datasets_pkey" primary key (id),
  constraint "geography" foreign key (geography_id) references public.geographies(id) on delete cascade
);

alter table "public"."datasets"
  enable row level security;

alter table "public"."datasets"
  add column "name" public.epiphet default null::name;

alter table "public"."datasets"
  add column "name_long" text;

alter table "public"."datasets"
  add column "deployment" public.environments[] default ARRAY[]::public.environments[];

alter table "public"."datasets"
  add column "flagged" boolean default false;

alter table "public"."datasets"
  add column "vectors_configuration" jsonb;

alter table "public"."datasets"
  add column "category_overrides" jsonb default 'null'::jsonb;

alter table "public"."datasets"
  add column "source_files" jsonb default '[]'::jsonb;

alter table "public"."datasets"
  add column "processed_files" jsonb default '[]'::jsonb;

alter table "public"."datasets"
  add column "metadata" jsonb default
    jsonb_build_object('description', null::unknown, 'suggested_citation', null::unknown, 'cautions', null::unknown, 'spatial_resolution', null::unknown, 'license', null::unknown,
    'sources', null::unknown, 'content_date', null::unknown, 'download_original_url', null::unknown, 'learn_more_url', null::unknown);

alter table "public"."datasets"
  add column "created" date default CURRENT_DATE;

alter table "public"."datasets"
  add column "created_by" character varying(64);

alter table "public"."datasets"
  add column "updated" timestamp with time zone default current_timestamp;

alter table "public"."datasets"
  add column "updated_by" character varying(64);

alter table "public"."datasets"
  add column "notification_interval" text;

alter table "public"."datasets"
  add column "notification_latest" date;

alter table "public"."datasets"
  add column "mutant_configuration" jsonb;

alter table "public"."datasets"
  add column "private" boolean default false;

alter table "public"."datasets"
  add column "name_long_translations" jsonb;

alter table "public"."datasets"
  add column "description_translations" jsonb;

alter table "public"."datasets"
  add column "cautions_translations" jsonb;

alter table "public"."datasets"
  add column "license_translations" jsonb;

alter table "public"."datasets"
  add column "sources_translations" jsonb;

alter table "public"."datasets"
  add column "suggested_citation_translations" jsonb;

alter table "public"."datasets"
  add constraint "datasets_geography_id_name_key" unique (geography_id, name);

alter table "public"."datasets"
  add constraint "datasets_geography_id_name_long_key" unique (geography_id, name_long);

alter table "public"."datasets"
  add constraint "datasets_notification_interval_check" check ((notification_interval ~ '^[0-9]{1,2} (day|week|month|year)s?$'::text));

create index datasets_category_id_idx on public.datasets using btree (category_id);

create trigger datasets_before_create
  before insert on public.datasets
  for each row
  execute function private.before_any_create();

create trigger datasets_before_update
  before update on public.datasets
  for each row
  execute function private.before_any_update();

create trigger datasets_flagged_notify
  before update on public.datasets
  for each row
  execute function private.datasets_flagged();

create trigger datasets_flagged
  before update on public.datasets
  for each row
  execute function private.flagged();

create trigger datasets_publish
  before update on public.datasets
  for each row
  execute function private.datasets_publish();

create policy "access_check_admin" on "public"."datasets"
  for all
  to PUBLIC
  using
    (((rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND (not private) AND rls.access_check(rls.current_user_id(),
    public.circles(datasets.*), deployment)));

create policy "access_check_guest" on "public"."datasets"
  for select
  to PUBLIC
  using
    (((rls.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND (not private) AND rls.access_check(rls.current_user_id(),
    public.circles(datasets.*), deployment)));

create policy "public_select" on "public"."datasets"
  for select
  to PUBLIC
  using (((not flagged) AND (not private) AND ('public'::public.environments = ANY (deployment))));

create policy "publish_select" on "public"."datasets"
  for select
  to PUBLIC
  using ((private AND rls.datasets_allowed(id, 'publish'::public.permission_types)));

create policy "publish" on "public"."datasets"
  for update
  to PUBLIC
  using ((private AND rls.datasets_allowed(id, 'publish'::public.permission_types)));

create policy "read" on "public"."datasets"
  for select
  to PUBLIC
  using ((private AND rls.datasets_allowed(id, 'read'::public.permission_types)));

create policy "superusers" on "public"."datasets"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

create policy "write_select" on "public"."datasets"
  for select
  to PUBLIC
  using (rls.datasets_allowed(id, 'write'::public.permission_types));

create policy "write" on "public"."datasets"
  for update
  to PUBLIC
  using (rls.datasets_allowed(id, 'write'::public.permission_types));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets" to "anon", "authenticated";

revoke all on table "public"."datasets" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets" to "service_role";
