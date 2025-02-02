--
-- Name: geographies superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.geographies USING ((public.current_user_role() = ANY (ARRAY['director'::text, 'root'::text])));
