--
-- Name: snapshots snapshots_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
