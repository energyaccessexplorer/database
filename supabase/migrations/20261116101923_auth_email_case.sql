-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
SET LOCAL check_function_bodies = off;
CREATE OR REPLACE FUNCTION private.handle_user_update()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	-- Auth lowercases addresses; public.users keeps the case it was given.
	update public.users set email = new.email
		where id = new.id and lower(email) <> lower(new.email);

	return new;
end $function$;
COMMIT;
