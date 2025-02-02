--
-- Name: users same_circle; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY same_circle ON public.users USING (((public.current_user_role() = ANY (ARRAY['leader'::text, 'manager'::text])) AND ((role)::public.users_enum < (public.current_user_role())::public.users_enum) AND (public.current_user_data('circles'::text) ?| ARRAY( SELECT json_array_elements_text(((users.data -> 'circles'::text))::json) AS json_array_elements_text))));
