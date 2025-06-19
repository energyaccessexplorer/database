--
-- Name: datasets access_check_guest; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY access_check_guest ON public.datasets FOR SELECT USING (((public.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND (NOT private) AND public.access_check(public.current_user_id(), public.circles(datasets.*), deployment)));
