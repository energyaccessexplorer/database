--
-- Name: snapshots snapshots_geography_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_geography_id_fkey FOREIGN KEY (geography_id) REFERENCES public.geographies(id);
