--
-- Name: geographies guest_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY guest_select ON public.geographies FOR SELECT USING (((NOT flagged) AND (public.current_user_role() = 'guest'::text) AND public.envs_check(deployment) AND public.circle_check(circle)));
