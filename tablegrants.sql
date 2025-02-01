-- create role guest;
grant select on all tables in schema public to guest;

grant select on geographies_tree_up to public;
grant select on geographies_tree_down to public;

-- SESSIONS/SNAPSHOTS

grant select, insert, update on sessions to public;
grant select, insert, update on snapshots to public;
