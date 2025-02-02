--
-- Name: users email_change_check; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER email_change_check BEFORE UPDATE ON public.users FOR EACH ROW WHEN ((new.email <> old.email)) EXECUTE FUNCTION public.email_change_fail();
