create or replace function authenticator.check_check()
  returns json
  language plpgsql
  stable
  security definer
  set search_path to 'pg_catalog'
  AS $function$
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
end $function$;
