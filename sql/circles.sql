create function circles_create(text)
returns boolean as $$ begin
	execute format('
		create role %1$s nologin;
		grant all on all tables in schema public to %1$s;
	', $1);

	return true;
end $$ language plpgsql;

create function circles_delete(n text)
returns boolean as $$ begin
	execute format('
		revoke all on all tables in schema public from %1$s;
		drop owned by %1$s;
		drop role %1$s;
	', $1);

	return true;
end $$ language plpgsql;
