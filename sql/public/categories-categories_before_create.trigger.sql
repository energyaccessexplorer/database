--
-- Name: categories categories_before_create; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_before_create BEFORE INSERT ON public.categories FOR EACH ROW EXECUTE FUNCTION public.before_any_create();
