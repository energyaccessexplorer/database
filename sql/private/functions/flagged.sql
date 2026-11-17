create or replace function private.flagged()
  returns trigger
  language plpgsql
  immutable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	if (new.flagged and array_position(new.deployment, 'public') > -1) then
		new.deployment = array_remove(new.deployment, 'public');
		raise notice 'Flagged row. Removed "public" from deployment.';
	end if;

	return new;
end $function$;

revoke all on function "private"."flagged"() from public;

grant execute on function "private"."flagged"() to "anon", "authenticated", "service_role";
