--
-- Name: users users_auth0_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_auth0_key UNIQUE (rwid);
