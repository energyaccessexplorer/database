--
-- Name: users manager_other; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY manager_other ON public.users FOR SELECT USING (((public.current_user_role() = ANY (ARRAY['leader'::public.roles, 'manager'::public.roles])) AND public.users_access(public.current_user_id(), id)));
