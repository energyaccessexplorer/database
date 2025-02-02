--
-- Name: datasets circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY circles_deployments ON public.datasets USING (((public.current_user_role() = ANY (ARRAY['admin'::text, 'leader'::text, 'manager'::text])) AND public.circle_check(public.geography_circle(geography_id)) AND (public.envs_check(deployment) OR (array_length(deployment, 1) IS NULL))));
