--
-- Name: datasets_permissions datasets_permissions_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_permissions
    ADD CONSTRAINT datasets_permissions_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
