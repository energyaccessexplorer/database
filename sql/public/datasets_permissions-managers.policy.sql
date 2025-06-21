--
-- Name: datasets_permissions managers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY managers ON public.datasets_permissions USING (((public.current_user_role() = ANY (ARRAY['manager'::public.roles])) AND public.datasets_permissions_check(public.current_user_id(), dataset_id)));
