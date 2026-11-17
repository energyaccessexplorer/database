create or replace function private.before_any_update()
  returns trigger
  language plpgsql
  immutable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	if (old.updated_by != new.updated_by) or
		(old.created_by != new.created_by) or
		(old.updated != new.updated) or
		(old.created != new.created)
	then
		raise exception 'Columns "updated", "updated_by", "created" and "created_by" are not editable';
	end if;

	new.updated = current_timestamp;
	new.updated_by = current_user_email();

	return new;
end $function$;

revoke all on function "private"."before_any_update"() from public;

grant execute on function "private"."before_any_update"() to "anon", "authenticated", "service_role";
