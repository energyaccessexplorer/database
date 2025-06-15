--
-- Name: access manager; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manager ON public.access USING (((public.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND public.access_access(public.current_user_id(), (circle)::name, deployment)));
