--
-- Name: snapshots snapshots_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions("time") ON DELETE CASCADE;
