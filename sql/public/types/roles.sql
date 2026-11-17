create type "public"."roles" as enum (
  'guest',
  'guest-admin',
  'admin',
  'leader',
  'manager',
  'director',
  'root'
);
