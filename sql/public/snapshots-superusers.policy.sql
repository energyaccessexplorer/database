--
-- Name: snapshots superusers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY superusers ON public.snapshots USING ((public.current_user_role() = ANY (ARRAY['director'::public.roles, 'root'::public.roles])));
