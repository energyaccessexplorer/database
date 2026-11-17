create table "public"."geographies" (
  "id"            uuid                  not null default gen_random_uuid(),
  "name"          character varying(64),
  "adm"           integer,
  "envelope"      double precision[]    default ARRAY[]::double precision[],
  "resolution"    integer               default 1000,
  "parent_id"     uuid,
  "configuration" jsonb                 default
    jsonb_build_object('boundaries_name', null::unknown, 'timeline', false, 'timeline_dates', null::unknown, 'flag', null::unknown, 'sort_branches', ARRAY[]::text[],
    'sort_subbranches', ARRAY[]::text[], 'sort_datasets', ARRAY[]::text[]),
  constraint "geographies_envelope_check"
    check
    (((envelope[1] >= ('-180'::integer)::double precision) AND (envelope[3] <= (180)::double precision) AND (envelope[1] < envelope[3]) AND (envelope[2] >= ('-90'::integer)::double
    precision) AND (envelope[4] <= (90)::double precision) AND (envelope[2] < envelope[4]))),
  constraint "geographies_pkey" primary key (id),
  constraint "parent" foreign key (parent_id) references public.geographies(id)
);

alter table "public"."geographies"
  enable row level security;

alter table "public"."geographies"
  add column "deployment" public.environments[] default ARRAY[]::public.environments[];

alter table "public"."geographies"
  add column "flagged" boolean default false;

alter table "public"."geographies"
  add column "created" date default CURRENT_DATE;

alter table "public"."geographies"
  add column "created_by" character varying(64);

alter table "public"."geographies"
  add column "updated" timestamp with time zone default current_timestamp;

alter table "public"."geographies"
  add column "updated_by" character varying(64);

alter table "public"."geographies"
  add column "area" bigint;

alter table "public"."geographies"
  add column "circles" public.epiphet[] default ARRAY[]::public.epiphet[];

create index geographies_parent_id_idx on public.geographies using btree (parent_id);

create trigger geographies_before_create
  before insert on public.geographies
  for each row
  execute function private.before_any_create();

create trigger geographies_before_update
  before update on public.geographies
  for each row
  execute function private.before_any_update();

create trigger geographies_flagged
  before update on public.geographies
  for each row
  execute function private.flagged();

create policy "access_check_admin" on "public"."geographies"
  for all
  to PUBLIC
  using
    (((rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND rls.access_check(rls.current_user_id(), circles,
    deployment)));

create policy "access_check_guest" on "public"."geographies"
  for select
  to PUBLIC
  using (((rls.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND rls.access_check(rls.current_user_id(), circles, deployment)));

create policy "public_select" on "public"."geographies"
  for select
  to PUBLIC
  using (((not flagged) AND ('public'::public.environments = ANY (deployment))));

create policy "superusers" on "public"."geographies"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies" to "anon", "authenticated";

revoke all on table "public"."geographies" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies" to "service_role";
