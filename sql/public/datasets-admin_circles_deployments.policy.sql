--
-- Name: datasets admin_circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_circles_deployments ON public.datasets USING (((NOT private) AND (public.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND public.circle_check(public.geography_circle(datasets.*)) AND (public.envs_check(deployment) OR (array_length(deployment, 1) IS NULL))));
