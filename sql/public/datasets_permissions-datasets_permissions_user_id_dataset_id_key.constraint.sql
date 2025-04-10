--
-- Name: datasets_permissions datasets_permissions_user_id_dataset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_permissions
    ADD CONSTRAINT datasets_permissions_user_id_dataset_id_key UNIQUE (user_id, dataset_id);
