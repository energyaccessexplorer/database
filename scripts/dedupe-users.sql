-- Consolidates users whose emails differ only in case into one row per
-- address. Winner precedence: role, then an existing Auth account, then id;
-- losers fill gaps in the winner's metadata and their rows move to it.
-- Run as a superuser (touches auth.users, bypasses RLS). Idempotent.

do $$
declare
	grp record;
	win record;
	los record;
	merged int := 0;
begin
	for grp in
		select lower(email) as le
		from public.users
		group by 1
		having count(*) > 1
	loop
		select * into win
		from public.users u
		where lower(u.email) = grp.le
		order by u.role desc nulls last,
			(exists (select 1 from auth.users a where a.id = u.id)) desc,
			u.id
		limit 1;

		for los in
			select * from public.users u
			where lower(u.email) = grp.le and u.id <> win.id
		loop
			update public.users set
				about = coalesce(los.about, '{}'::jsonb) || about,
				rwid = coalesce(rwid, los.rwid),
				disabled = coalesce(disabled, los.disabled)
			where id = win.id;

			update public.datasets_permissions p set user_id = win.id
			where p.user_id = los.id
				and not exists (
					select 1 from public.datasets_permissions q
					where q.user_id = win.id and q.dataset_id = p.dataset_id);
			delete from public.datasets_permissions where user_id = los.id;

			update public.access a set user_id = win.id
			where a.user_id = los.id
				and not exists (
					select 1 from public.access b
					where b.user_id = win.id and b.circle = a.circle and b.deployment = a.deployment);
			delete from public.access where user_id = los.id;

			update public.follows f set user_id = win.id
			where f.user_id = los.id
				and not exists (
					select 1 from public.follows g
					where g.user_id = win.id and g.dataset_id = f.dataset_id);
			delete from public.follows where user_id = los.id;

			update public.snapshots set user_id = win.id where user_id = los.id;

			delete from auth.users where id = los.id;
			delete from public.users where id = los.id;

			merged := merged + 1;
			raise notice 'merged % (%) into % (%)',
				los.email, los.id, win.email, win.id;
		end loop;
	end loop;

	-- Auth stores lowercase addresses; the legacy data carried its own case.
	update auth.users set email = lower(email) where email <> lower(email);
	update public.users set email = lower(email) where email <> lower(email);

	for los in
		select u.id, u.email from public.users u
		where not exists (select 1 from auth.users a where a.id = u.id)
	loop
		raise notice 'no Auth account for % (%)', los.email, los.id;
	end loop;

	raise notice 'merged % duplicate rows', merged;
end $$;
