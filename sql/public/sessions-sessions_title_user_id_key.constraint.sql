--
-- Name: sessions sessions_title_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_title_user_id_key UNIQUE (title, user_id);
