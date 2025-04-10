--
-- Name: datasets datasets_publish; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER datasets_publish BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION public.datasets_publish();
