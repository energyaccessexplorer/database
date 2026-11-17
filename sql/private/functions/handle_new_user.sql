create or replace function private.handle_new_user()
  returns trigger
  language plpgsql
  security definer
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$ begin
	-- Signup metadata is the subscribe form's answers (mailing consent
	-- included); the same shape the legacy users.about carried.
	insert into public.users (id, email, about)
		values (new.id, new.email, coalesce(new.raw_user_meta_data, '{}'::jsonb))
		on conflict (id) do nothing;

	return new;
end $function$;

revoke all on function "private"."handle_new_user"() from public;

grant execute on function "private"."handle_new_user"() to "anon", "authenticated", "service_role";
