-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
SET LOCAL check_function_bodies = off;
DROP POLICY "self" ON "public"."users";
DROP TRIGGER "email_change_check" ON "public"."users";
CREATE OR REPLACE FUNCTION private.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'rls', 'private', 'pg_catalog'
AS $function$ begin
	insert into public.users (id, email)
		values (new.id, new.email)
		on conflict (id) do nothing;

	return new;
end $function$;
CREATE TRIGGER email_change_check BEFORE UPDATE ON public.users FOR EACH ROW WHEN (((new.email <> old.email) AND (CURRENT_USER <> 'postgres'::name))) EXECUTE FUNCTION private.email_change_fail();
CREATE POLICY "self" ON "public"."users" FOR ALL TO PUBLIC USING ((id = rls.current_user_id()));
COMMIT;
