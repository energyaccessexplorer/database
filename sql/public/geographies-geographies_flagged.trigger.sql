--
-- Name: geographies geographies_flagged; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geographies_flagged BEFORE UPDATE ON public.geographies FOR EACH ROW EXECUTE FUNCTION public.flagged();
