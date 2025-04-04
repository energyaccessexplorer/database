--
-- Name: datasets admin_circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY admin_circles_deployments ON public.datasets USING (((public.current_user_role() = ANY (ARRAY['admin'::text, 'leader'::text, 'manager'::text])) AND public.circle_check(public.geography_circle(datasets.*)) AND (public.envs_check(deployment) OR (array_length(deployment, 1) IS NULL))));
