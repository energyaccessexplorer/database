--
-- Name: users superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.users USING ((public.current_user_role() = ANY (ARRAY['director'::text, 'root'::text])));
