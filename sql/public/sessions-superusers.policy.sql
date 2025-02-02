--
-- Name: sessions superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.sessions USING ((public.current_user_role() = ANY (ARRAY['director'::text, 'root'::text])));
