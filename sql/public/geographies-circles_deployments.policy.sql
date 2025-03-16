--
-- Name: geographies circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY circles_deployments ON public.geographies USING (((public.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND public.circle_check(circle) AND public.envs_check(deployment)));
