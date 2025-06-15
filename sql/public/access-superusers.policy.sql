--
-- Name: access superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.access USING ((public.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
