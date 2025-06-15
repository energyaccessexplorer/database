--
-- Name: geographies access_check_guest; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY access_check_guest ON public.geographies FOR SELECT USING (((public.current_user_role() = ANY (ARRAY['guest'::public.roles, 'guest-admin'::public.roles])) AND public.access_check(public.current_user_id(), (circle)::name, deployment)));
