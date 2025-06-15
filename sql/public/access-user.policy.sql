--
-- Name: access user; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "user" ON public.access FOR SELECT USING ((user_id = public.current_user_id()));
