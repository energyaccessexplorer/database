--
-- Name: access user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.access
    ADD CONSTRAINT "user" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
