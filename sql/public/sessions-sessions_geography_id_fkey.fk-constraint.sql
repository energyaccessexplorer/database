--
-- Name: sessions sessions_geography_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_geography_id_fkey FOREIGN KEY (geography_id) REFERENCES public.geographies(id);
