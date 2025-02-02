--
-- Name: users upgrade_check; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER upgrade_check BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW WHEN (((new.role)::public.users_enum > (public.current_user_role())::public.users_enum)) EXECUTE FUNCTION public.upgrade_fail();
