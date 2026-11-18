-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
ALTER TABLE "public"."datasets" ADD COLUMN "paver_params" jsonb;
COMMENT ON COLUMN "public"."datasets"."paver_params" IS 'the parameters paver was run with: {"routine": text, "params": object, "origin": "admin" | "inferred", "check": {"status": text}, "at": timestamp}';
COMMIT;
