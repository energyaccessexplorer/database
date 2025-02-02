--
-- Name: follows follows_before_create; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER follows_before_create BEFORE INSERT ON public.follows FOR EACH ROW EXECUTE FUNCTION public.before_any_create();
