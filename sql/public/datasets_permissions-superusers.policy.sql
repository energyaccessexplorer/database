--
-- Name: datasets_permissions superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.datasets_permissions USING ((public.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
