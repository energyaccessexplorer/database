-- Local seed only: the legacy geotiff endpoints name a dev-server route that
-- no longer exists; the objects live in the geotiff-test bucket of the stack
-- at :base (its SUPABASE_URL). Idempotent.

update public.datasets
set processed_files = (
	select jsonb_agg(
		case when e->>'endpoint' like '%/geotiff-test/%'
		then jsonb_set(e, '{endpoint}', to_jsonb(regexp_replace(e->>'endpoint',
			'^(https?://[^/]+)?(/storage/v1/object/public)?/geotiff-test/',
			:'base' || '/storage/v1/object/public/geotiff-test/')))
		else e end)
	from jsonb_array_elements(processed_files) e)
where processed_files::text like '%/geotiff-test/%';
