--
-- Name: users circles_change_check; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER circles_change_check BEFORE UPDATE ON public.users FOR EACH ROW WHEN ((new.data <> old.data)) EXECUTE FUNCTION public.circles_change_check();
