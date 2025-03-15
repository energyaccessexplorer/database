--
-- Name: datasets guest_circles_deployments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY guest_circles_deployments ON public.datasets FOR SELECT USING (((public.current_user_role() = ANY (ARRAY['guest'::roles, 'guest-admin'::roles])) AND public.circle_check(public.geography_circle(datasets.*)) AND (public.envs_check(deployment) OR (array_length(deployment, 1) IS NULL))));
