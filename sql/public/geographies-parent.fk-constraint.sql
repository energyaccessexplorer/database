--
-- Name: geographies parent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geographies
    ADD CONSTRAINT parent FOREIGN KEY (parent_id) REFERENCES public.geographies(id);
