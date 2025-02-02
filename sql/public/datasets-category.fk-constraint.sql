--
-- Name: datasets category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT category FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;
