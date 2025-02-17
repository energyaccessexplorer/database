--
-- Name: snapshots owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY owner ON public.snapshots USING ((user_id = public.current_user_id()));
