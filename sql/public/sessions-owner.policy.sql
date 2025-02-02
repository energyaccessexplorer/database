--
-- Name: sessions owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY owner ON public.sessions USING ((user_id = public.current_user_id()));
