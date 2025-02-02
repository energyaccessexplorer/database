--
-- Name: users users_rwid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_rwid_key UNIQUE (rwid);
