create extension unaccent;
create extension pgcrypto;
create extension pgjwt;     -- https://github.com/michelp/pgjwt

create role root nologin;
create role admin nologin;
create role master nologin;
create role guest nologin;
create role member nologin;

create domain epiphet as name check (value ~ '^[a-z][a-z0-9\-]+$');
