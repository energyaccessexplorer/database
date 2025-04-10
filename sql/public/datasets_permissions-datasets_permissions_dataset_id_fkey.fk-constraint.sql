--
-- Name: datasets_permissions datasets_permissions_dataset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_permissions
    ADD CONSTRAINT permissions_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);
