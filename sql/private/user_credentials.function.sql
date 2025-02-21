--
-- Name: user_credentials(); Type: FUNCTION; Schema: private; Owner: -
--

CREATE FUNCTION private.user_credentials() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
declare
	_id    text := current_setting('request.jwt.claims', true)::jsonb->>'id';
	u users;
begin
	if _id is null then
		perform set_config('user.id',    null,   true);
		perform set_config('user.email', null,   true);
		perform set_config('user.data', 'null',  true);
		perform set_config('user.role', 'guest', true);
		return;
	end if;

	if _id ~ '^[0-9a-f]{24}$' then
		select * from users where rwid = _id into u;
	else
		select * from users where id = _id::uuid into u;
	end if;

	if u is null and then
		raise exception 'Unknown credentials';
	end if;

	if u.disabled then
		raise exception 'User disabled';
	end if;

	perform set_config('user.id',    u.id::text,    true);
	perform set_config('user.email', u.email::text, true);
	perform set_config('user.data',  u.data::text,  true);
	perform set_config('user.role',  u.role::text,  true);
end
$_$;
