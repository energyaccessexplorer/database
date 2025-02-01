alter table users enable row level security;

-- GUEST

create policy self on users
	using (email = current_user_email());

-- ADMIN

create policy superusers on users
	using (current_user_role() in ('director', 'root'));

create policy same_circle on users
using (
	current_user_data('circles') ?| array(select json_array_elements_text((data->'circles')::json))::text[] and
	current_user_role() in ('leader', 'manager') and
	role::users_enum < current_user_role()::users_enum
);
