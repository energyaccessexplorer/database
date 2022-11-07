grant select on all tables in schema public to guest;
grant select on all tables in schema public to adminguest;

-- ROLES

grant all on datasets to admin;
grant select on all tables in schema public to admin;

grant admin to leader;
grant all on geographies to leader;

grant leader to master;
grant all on categories to master;

grant all on all tables in schema public to root;
