create table "public"."users" (
  "email"    text    not null,
  "about"    jsonb   default '{}'::jsonb,
  "id"       uuid    not null default gen_random_uuid(),
  "rwid"     text,
  "disabled" boolean default false,
  constraint "users_email_check" check ((email ~ '^[a-zA-Z0-9\''.+_-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
  constraint "users_email_key" unique (email),
  constraint "users_pkey" primary key (id),
  constraint "users_rwid_check" check ((rwid ~ '^[0-9a-f]{24}$'::text)),
  constraint "users_rwid_key" unique (rwid)
);

alter table "public"."users"
  enable row level security;

alter table "public"."users"
  add column "role" public.roles default 'guest'::public.roles;

create trigger delete_self
  before delete on public.users
  for each row
  when ((old.id = rls.current_user_id()))
  execute function private.delete_self();

create trigger email_change_check
  before update on public.users
  for each row
  when (((new.email <> old.email) and (current_user <> 'postgres'::name)))
  execute function private.email_change_fail();

create trigger upgrade_check_insert
  before insert on public.users
  for each row
  when ((new.role > rls.current_user_role()))
  execute function private.upgrade_fail();

create trigger upgrade_check_update
  before update on public.users
  for each row
  when (((new.role IS DISTINCT FROM old.role) AND (new.role > rls.current_user_role())))
  execute function private.upgrade_fail();

create policy "manager_other" on "public"."users"
  for select
  to PUBLIC
  using (((rls.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND rls.users_access(rls.current_user_id(), id)));

create policy "manager" on "public"."users"
  for all
  to PUBLIC
  using
    (((rls.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND (role < rls.current_user_role()) AND rls.users_access(rls.current_user_id(),
    id)));

create policy "self" on "public"."users"
  for all
  to PUBLIC
  using ((id = rls.current_user_id()));

create policy "superusers" on "public"."users"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."users" to "anon", "authenticated";

revoke all on table "public"."users" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."users" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."users" to "service_role";
