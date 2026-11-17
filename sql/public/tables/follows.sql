create table "public"."follows" (
  "email"      text,
  "dataset_id" uuid                  not null,
  "created"    date                  default CURRENT_DATE,
  "created_by" character varying(64),
  "user_id"    uuid                  not null,
  constraint "follows_dataset_id_fkey" foreign key (dataset_id) references public.datasets(id) on delete cascade,
  constraint "follows_user_id_dataset_id_key" unique (user_id, dataset_id),
  constraint "follows_user_id_fkey" foreign key (user_id) references public.users(id) on delete cascade
);

alter table "public"."follows"
  enable row level security;

create index follows_dataset_id_idx on public.follows using btree (dataset_id);

create trigger follows_before_create
  before insert on public.follows
  for each row
  execute function private.before_any_create();

create policy "superusers" on "public"."follows"
  for all
  to PUBLIC
  using ((rls.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."follows" to "anon", "authenticated";

revoke all on table "public"."follows" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."follows" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."follows" to "service_role";
