create table "private"."events_queue" (
  "message" jsonb
);

alter table "private"."events_queue"
  enable row level security;

create policy "insert_only" on "private"."events_queue"
  for insert
  to "authenticated", "service_role"
  with check (true);

grant delete, insert, maintain, references, select, trigger, truncate, update on table "private"."events_queue" to "anon";

grant insert, maintain, references, trigger, truncate on table "private"."events_queue" to "authenticated", "service_role";
