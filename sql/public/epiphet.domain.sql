--
-- Name: epiphet; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.epiphet AS name
	CONSTRAINT epiphet_check CHECK ((VALUE ~ '^[a-z][a-z0-9\-]+$'::text));
