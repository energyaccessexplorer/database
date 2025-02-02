--
-- Name: datasets datasets_before_create; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER datasets_before_create BEFORE INSERT ON public.datasets FOR EACH ROW EXECUTE FUNCTION public.before_any_create();
