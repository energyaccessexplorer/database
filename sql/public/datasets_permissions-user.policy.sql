--
-- Name: datasets_permissions user; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "user" ON public.datasets_permissions FOR SELECT USING ((user_id = public.current_user_id()));
