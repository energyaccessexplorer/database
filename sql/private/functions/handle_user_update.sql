create or replace function private.handle_user_update()
  returns trigger
  language plpgsql
  security definer
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	-- Auth lowercases addresses; public.users keeps the case it was given.
	update public.users set email = new.email
		where id = new.id and lower(email) <> lower(new.email);

	return new;
end $function$;

revoke all on function "private"."handle_user_update"() from public;

grant execute on function "private"."handle_user_update"() to "anon", "authenticated", "service_role";
