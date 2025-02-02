--
-- Name: categories superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.categories USING ((public.current_user_role() = ANY (ARRAY['director'::text, 'root'::text])));
