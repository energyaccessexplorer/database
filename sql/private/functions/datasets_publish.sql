create or replace function private.datasets_publish()
  returns trigger
  language plpgsql
  immutable
  set search_path to 'public', 'rls', 'private', 'pg_catalog'
  AS $function$
declare
	added environments[];
	removed environments[];
	allowed environments[];
begin
	if current_user_role() > 'manager'::roles then
		return new;
	end if;

    if true and
        new.deployment @> old.deployment and
        new.deployment <@ old.deployment then
        return new;
    end if;

	select array_agg(x) from unnest(new.deployment) x where x not in (select unnest(old.deployment)) into added;
	select array_agg(x) from unnest(old.deployment) x where x not in (select unnest(new.deployment)) into removed;

	select array_agg(deployment) from access a
	where a.user_id = current_user_id()
		and a.circle = ANY (circles(new))
	into allowed;

	if ((added <@ allowed) and (removed <@ allowed)) then
		return new;
	end if;

	if (not added <@ allowed) then
		raise exception 'You cannot add access you do not belong to yourself (added %), (allowed %)', added, allowed;
	end if;

	if (not removed <@ allowed) then
		raise exception 'You cannot remove access you do not belong to yourself (removed %), (allowed %)', removed, allowed;
	end if;

    return new;
end $function$;

revoke all on function "private"."datasets_publish"() from public;

grant execute on function "private"."datasets_publish"() to "anon", "authenticated", "service_role";
