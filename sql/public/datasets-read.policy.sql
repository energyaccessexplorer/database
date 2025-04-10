--
-- Name: datasets read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY read ON public.datasets FOR SELECT USING ((private AND public.datasets_allowed(id, 'read'::public.permission_types)));
