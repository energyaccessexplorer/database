--
-- Name: datasets_permissions dataset; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_permissions
    ADD CONSTRAINT dataset FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);
