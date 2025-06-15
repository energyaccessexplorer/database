--
-- Name: users manager; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manager ON public.users USING (((public.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND (role < public.current_user_role()) AND public.users_access(public.current_user_id(), id)));
