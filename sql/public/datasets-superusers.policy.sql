--
-- Name: datasets superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.datasets USING ((public.current_user_role() = ANY (ARRAY['director'::text, 'root'::text])));
