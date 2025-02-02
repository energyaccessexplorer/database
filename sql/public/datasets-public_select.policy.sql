--
-- Name: datasets public_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY public_select ON public.datasets FOR SELECT USING (((NOT flagged) AND ('production'::public.environments = ANY (deployment))));
