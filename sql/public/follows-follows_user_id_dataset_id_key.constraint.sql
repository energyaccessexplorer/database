--
-- Name: follows follows_user_id_dataset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_user_id_dataset_id_key UNIQUE (user_id, dataset_id);
