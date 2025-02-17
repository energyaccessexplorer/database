--
-- Name: user_upsert(json); Type: FUNCTION; Schema: authenticator; Owner: -
--

CREATE FUNCTION authenticator.user_upsert(json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
declare
	_id uuid;
	_email text;
	_rwid text;
	_about jsonb;
begin
	if (current_setting('request.headers', true)::json->>'x-authenticator-psk' = current_setting('app.settings.authenticator_psk')) then
		update users u set email = $1->>'email' where rwid = $1->>'rwid';

		insert into users as u (email, rwid, about)
			values ($1->>'email', $1->>'rwid', $1->'about')
			on conflict (email) do update set
				email = coalesce($1->>'email', u.email),
				rwid = coalesce($1->>'rwid', u.rwid),
				about = coalesce(($1->>'about')::jsonb, u.about::jsonb)
			returning id, email, rwid, about into _id, _email, _rwid, _about;

		perform set_config('response.status', '200', true);
		return json_build_object('id', _id, 'email', _email, 'rwid', _rwid, 'about', _about);
	end if;

	perform set_config('response.status', '401', true);
	return json_build_object(
		'message', 'Wrong authentication headers',
		'hint', 'Check ''em'
	);
end $_$;
