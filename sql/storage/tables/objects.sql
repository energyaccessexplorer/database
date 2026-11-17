create policy "admin_upload" on "storage"."objects"
  for insert
  to "authenticated"
  with
    check
    (((bucket_id = 'wri-public-data'::text) AND (name ~~ 'EnergyAccess/uploads/%'::text) AND (rls.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles,
    'manager'::public.roles, 'director'::public.roles, 'root'::public.roles]))));
