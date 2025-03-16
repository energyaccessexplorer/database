--
-- Name: categories superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.categories USING ((public.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
