--
-- Name: snapshots snapshots_session_id_time_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_session_id_time_key UNIQUE (session_id, "time");
