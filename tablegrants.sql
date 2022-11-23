grant select on all tables in schema public to guest;
grant select on all tables in schema public to adminguest;

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
