--
-- Name: datasets access_check_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY access_check_admin ON public.datasets USING (((public.current_user_role() = ANY (ARRAY['admin'::public.roles, 'leader'::public.roles, 'manager'::public.roles])) AND (NOT private) AND public.access_check(public.current_user_id(), (public.circle(datasets.*))::name, deployment)));
