--
-- Name: datasets publish_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY publish_select ON public.datasets FOR SELECT USING ((private AND public.datasets_allowed(id, 'publish'::public.permission_types)));
