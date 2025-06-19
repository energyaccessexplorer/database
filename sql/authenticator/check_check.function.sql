--
-- Name: check_check(); Type: FUNCTION; Schema: authenticator; Owner: -
--

CREATE FUNCTION authenticator.check_check() RETURNS json
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
declare
	setting text := current_setting('app.settings.authenticator_psk')::text;
	header text := (current_setting('request.headers', true)::json->>'x-authenticator-psk')::text;
begin
	if (header = setting) then
		return json_build_object(
			'status', 'OK'
		);
	end if;

	perform set_config('response.status', '401', true);

	return json_build_object(
		'message', 'wrong x-authenticator-psk headers',
		'hint', 'provided header: ' || coalesce(header, '<none>')
	);
end $$;
