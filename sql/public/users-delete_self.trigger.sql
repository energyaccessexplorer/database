--
-- Name: users delete_self; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER delete_self BEFORE DELETE ON public.users FOR EACH ROW WHEN ((old.id = public.current_user_id())) EXECUTE FUNCTION public.delete_self();
