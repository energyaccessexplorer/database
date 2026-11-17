create or replace function private.datasets_flagged()
  returns trigger
  language plpgsql
  immutable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	if (not old.flagged and new.flagged) then
		perform event_create('dataset:flagged', jsonb_build_object(
			'id', new.id,
			'last_updated_by', old.updated_by
		));
	end if;

	return new;
end $function$;

revoke all on function "private"."datasets_flagged"() from public;

grant execute on function "private"."datasets_flagged"() to "anon", "authenticated", "service_role";
