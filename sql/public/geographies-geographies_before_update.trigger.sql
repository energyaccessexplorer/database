--
-- Name: geographies geographies_before_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geographies_before_update BEFORE UPDATE ON public.geographies FOR EACH ROW EXECUTE FUNCTION public.before_any_update();
