create function circles_create(rol name, parent name)
returns boolean as $$
declare
	is_member boolean;
begin
	select 'member' in
		(select a.rolname from pg_authid a where pg_has_role(parent, a.oid, 'member'))
	into is_member;

	if not is_member then
		raise exception 'NO NO NO!!';
	end if;

	execute format('
		create role %1$s nologin;
		grant %2$s to %1$s;
	', rol, parent);

	return true;
end $$ language plpgsql;

create function circles_create(rolname name)
returns boolean as $$ begin
	return circles_create(rolname, 'member');
end $$ language plpgsql;

create function circles_drop(rolname name)
returns boolean as $$ begin
	execute format('drop role %1$s;', rolname);
	return true;
end $$ language plpgsql;
