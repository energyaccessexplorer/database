--
-- Name: datasets geography; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT geography FOREIGN KEY (geography_id) REFERENCES public.geographies(id) ON DELETE CASCADE;
