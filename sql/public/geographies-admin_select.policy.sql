--
-- Name: geographies admin_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_select ON public.geographies FOR SELECT USING (((public.current_user_role() = 'admin'::text) AND public.circle_check(circle) AND public.envs_check(deployment)));
