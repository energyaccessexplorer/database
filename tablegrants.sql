grant select on all tables in schema public to guest;
grant all on all tables in schema public to admin;

grant select on geography_boundaries to public;

grant member to admin;
          grant admin to master;
                   grant master to root;
