--
-- Name: datasets datasets_geography_id_name_long_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_geography_id_name_long_key UNIQUE (geography_id, name_long);
