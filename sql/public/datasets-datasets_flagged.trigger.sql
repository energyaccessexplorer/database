--
-- Name: datasets datasets_flagged; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER datasets_flagged BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION public.flagged();
