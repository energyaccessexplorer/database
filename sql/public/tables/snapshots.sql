create table "public"."snapshots" (
  "time"   bigint,
  "config" jsonb,
  "title"  text
);

alter table "public"."snapshots"
  enable row level security;

alter table "public"."snapshots"
  add column "env" public.environments not null;

alter table "public"."snapshots"
  add column "user_id" uuid not null;

alter table "public"."snapshots"
  add column "geography_id" uuid not null;

alter table "public"."snapshots"
  add constraint "snapshots_geography_id_fkey" foreign key (geography_id) references public.geographies(id);

alter table "public"."snapshots"
  add constraint "snapshots_user_id_fkey" foreign key (user_id) references public.users(id);

create index snapshots_geography_id_idx on public.snapshots using btree (geography_id);

create index snapshots_user_id_idx on public.snapshots using btree (user_id);

create policy "owner" on "public"."snapshots"
  for all
  to PUBLIC
  using ((user_id = rls.current_user_id()));

create policy "superusers" on "public"."snapshots"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."snapshots" to "anon", "authenticated";

revoke all on table "public"."snapshots" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."snapshots" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."snapshots" to "service_role";
