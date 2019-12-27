create or replace function circles_create(name, name)
returns boolean as $$
declare
	is_member boolean;
begin
	select 'member' in
		(select a.rolname from pg_authid a WHERE pg_has_role($2, a.oid, 'member'))
	into is_member;

	if not is_member then
		raise exception 'OH! HELL NAW!';
	end if;

	execute format('
		create role %1$s nologin;
		grant %2$s to %1$s;
	', $1, $2);

	return true;
end $$ language plpgsql;

create function circles_create(name)
returns boolean as $$ begin
	return circles_create($1, 'member');
end $$ language plpgsql;

create function circles_delete(name)
returns boolean as $$ begin
	execute format('
		revoke all on all tables in schema public from %1$s;
		drop owned by %1$s;
		drop role %1$s;
	', $1);

	return true;
end $$ language plpgsql;
