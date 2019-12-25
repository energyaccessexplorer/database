create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

create role root nologin;
create role admin nologin;
create role master nologin;
create role guest nologin;

grant select on all tables in schema public to admin;
grant select on all tables in schema public to guest;

grant admin to master;
grant admin to root;

create domain epiphet as name check (value ~ '^[a-z][a-z0-9\-]+$');
