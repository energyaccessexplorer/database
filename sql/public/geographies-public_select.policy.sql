--
-- Name: geographies public_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY public_select ON public.geographies FOR SELECT USING (((NOT flagged) AND ('production'::public.environments = ANY (deployment))));
