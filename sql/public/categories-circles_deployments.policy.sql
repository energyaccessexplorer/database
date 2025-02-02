--
-- Name: categories circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY circles_deployments ON public.categories USING (((public.current_user_role() = 'manager'::text) AND public.circle_check(circle) AND public.envs_check(deployment)));
