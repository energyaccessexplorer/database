--
-- Name: users self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY self ON public.users USING ((email = public.current_user_email()));
