--
-- Name: datasets_permissions user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_permissions
    ADD CONSTRAINT "user" FOREIGN KEY (user_id) REFERENCES public.users(id);
