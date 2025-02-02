--
-- Name: datasets datasets_flagged_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER datasets_flagged_notify BEFORE UPDATE ON public.datasets FOR EACH ROW EXECUTE FUNCTION public.datasets_flagged();
