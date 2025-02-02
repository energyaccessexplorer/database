--
-- Name: geographies geographies_before_create; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geographies_before_create BEFORE INSERT ON public.geographies FOR EACH ROW EXECUTE FUNCTION public.before_any_create();
