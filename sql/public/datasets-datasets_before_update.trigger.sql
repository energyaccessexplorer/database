--
-- Name: datasets datasets_before_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER datasets_before_update BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION public.before_any_update();
