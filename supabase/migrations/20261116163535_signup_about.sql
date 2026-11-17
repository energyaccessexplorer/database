-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
SET LOCAL check_function_bodies = off;
CREATE OR REPLACE FUNCTION private.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	-- Signup metadata is the subscribe form's answers (mailing consent
	-- included); the same shape the legacy users.about carried.
	insert into public.users (id, email, about)
		values (new.id, new.email, coalesce(new.raw_user_meta_data, '{}'::jsonb))
		on conflict (id) do nothing;

	return new;
end $function$;
COMMIT;
