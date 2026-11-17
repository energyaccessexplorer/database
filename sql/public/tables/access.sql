create table "public"."access" (
  "user_id" uuid not null,
  constraint "user" foreign key (user_id) references public.users(id) on delete cascade
);

alter table "public"."access"
  enable row level security;

alter table "public"."access"
  add column "circle" public.epiphet not null;

alter table "public"."access"
  add column "deployment" public.environments not null;

alter table "public"."access"
  add constraint "access_pkey" primary key (user_id, circle, deployment);

create index access_user_circle_deployment_idx on public.access using btree (user_id, circle, deployment);

create index access_user_id_idx on public.access using btree (user_id);

create policy "manager" on "public"."access"
  for all
  to PUBLIC
  using (((rls.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND rls.access_access(rls.current_user_id(), (circle)::name, deployment)));

create policy "superusers" on "public"."access"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

create policy "user" on "public"."access"
  for select
  to PUBLIC
  using ((user_id = rls.current_user_id()));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."access" to "anon", "authenticated";

revoke all on table "public"."access" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."access" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."access" to "service_role";
