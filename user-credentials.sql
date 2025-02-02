create or replace function private.user_credentials()
returns void
language plpgsql security definer
as $$
declare
	_rwid uuid := current_setting('request.jwt.claims', true)::jsonb->>'id';
	u users;
begin
	if _rwid is null then
		perform set_config('user.id',    null,   true);
		perform set_config('user.email', null,   true);
		perform set_config('user.data', 'null',   true);
		perform set_config('user.role', 'guest', true);

		return;
	end if;

	select * from users where rwid = _rwid into u;

	if u is null and then
		raise exception 'Unknown credentials';
	end if;

	if u.disabled then
		raise exception 'User disabled';
	end if;

	perform set_config('user.id',    u.id::text,    true);
	perform set_config('user.role',  u.role::text,  true);
	perform set_config('user.data',  u.data::text,  true);
	perform set_config('user.email', u.email::text, true);
end
$$;
