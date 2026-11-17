create table "public"."datasets_permissions" (
  "user_id" uuid not null,
  constraint "user" foreign key (user_id) references public.users(id)
);

alter table "public"."datasets_permissions"
  enable row level security;

alter table "public"."datasets_permissions"
  add column "type" public.permission_types not null;

alter table "public"."datasets_permissions"
  add column "dataset_id" uuid not null;

alter table "public"."datasets_permissions"
  add column "created" date default CURRENT_DATE;

alter table "public"."datasets_permissions"
  add column "created_by" character varying(64);

alter table "public"."datasets_permissions"
  add column "updated" timestamp with time zone default current_timestamp;

alter table "public"."datasets_permissions"
  add column "updated_by" character varying(64);

alter table "public"."datasets_permissions"
  add constraint "datasets_permissions_user_id_dataset_id_key" unique (user_id, dataset_id);

alter table "public"."datasets_permissions"
  add constraint "dataset" foreign key (dataset_id) references public.datasets(id);

create index datasets_permissions_dataset_id_idx on public.datasets_permissions using btree (dataset_id);

create policy "managers" on "public"."datasets_permissions"
  for all
  to PUBLIC
  using (((rls.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND rls.datasets_permissions_check(rls.current_user_id(), dataset_id)));

create policy "superusers" on "public"."datasets_permissions"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

create policy "user" on "public"."datasets_permissions"
  for select
  to PUBLIC
  using ((user_id = rls.current_user_id()));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets_permissions" to "anon", "authenticated";

revoke all on table "public"."datasets_permissions" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets_permissions" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."datasets_permissions" to "service_role";
