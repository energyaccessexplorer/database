grant select on all tables in schema public to guest;
grant select on all tables in schema public to adminguest;

grant select on geographies_tree_up to public;
grant select on geographies_tree_down to public;

-- SESSIONS/SNAPSHOTS

grant select, insert, update on sessions to public;
grant select, insert, update on snapshots to public;

-- ROLES

grant all on datasets to admin;

grant select on all tables in schema public to admin;

grant admin to leader;
grant all on geographies to leader;

grant leader to manager;
grant all on categories to manager;

grant manager to director;
-- directors can access users too and are not restricted by circles

grant all on all tables in schema public to root;
