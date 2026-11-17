-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
CREATE POLICY "admin_upload" ON "storage"."objects" FOR INSERT TO "authenticated" WITH CHECK (((bucket_id = 'wri-public-data'::text) AND (name ~~ 'EnergyAccess/uploads/%'::text) AND (rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles, 'director'::public.roles, 'root'::public.roles]))));
COMMIT;
