create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function private.handle_new_user();

create trigger on_auth_user_updated
  after update of email, email_confirmed_at on auth.users
  for each row
  execute function private.handle_user_update();
