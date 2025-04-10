--
-- Name: datasets publish; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY publish ON public.datasets FOR UPDATE USING ((private AND public.datasets_allowed(id, 'publish'::public.permission_types)));
