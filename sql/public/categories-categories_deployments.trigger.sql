--
-- Name: categories categories_deployments; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_deployments BEFORE INSERT OR UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.categories_before_update();
