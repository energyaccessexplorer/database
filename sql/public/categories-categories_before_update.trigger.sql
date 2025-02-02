--
-- Name: categories categories_before_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_before_update BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.before_any_update();
