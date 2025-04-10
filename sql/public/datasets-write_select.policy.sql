--
-- Name: datasets write_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY write_select ON public.datasets FOR SELECT USING (public.datasets_allowed(id, 'write'::public.permission_types));
