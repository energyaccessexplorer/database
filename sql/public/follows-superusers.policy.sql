--
-- Name: follows superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.follows USING ((public.current_user_role() = ANY (ARRAY['director'::roles, 'root'::roles])));
