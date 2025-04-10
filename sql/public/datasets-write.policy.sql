--
-- Name: datasets write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY write ON public.datasets FOR UPDATE USING (public.datasets_allowed(id, 'write'::public.permission_types));
