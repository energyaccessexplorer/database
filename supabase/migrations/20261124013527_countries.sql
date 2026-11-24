-- pg-delta schema apply --dry-run
-- Execute statements one at a time, in order, on one database session.
-- Stop on the first error and preserve autocommit outside BEGIN/COMMIT blocks.
-- Do not submit this as one multi-statement request or wrap it in one transaction.

BEGIN;
SET LOCAL search_path = pg_catalog;
CREATE TABLE "public"."countries" ("cca3" character varying(3) NOT NULL, "cca2" character varying(2), "ccn3" character varying(3), "names" jsonb, "name" text GENERATED ALWAYS AS ((names ->> 'common'::text)) STORED, "tld" text[], "independent" boolean, "un_member" boolean, "currencies" jsonb, "capital" text, "phonecodes" text[], "region" text, "subregion" text, "latlng" double precision[], "lnglat" double precision[] GENERATED ALWAYS AS (ARRAY[latlng[2], latlng[1]]) STORED, "landlocked" boolean, "borders" character varying(3)[], "area" integer, "flag" bytea, CONSTRAINT "countries_cca2_key" UNIQUE (cca2), CONSTRAINT "countries_ccn3_check" CHECK (((ccn3)::text ~ '[0-9]{3}'::text)), CONSTRAINT "countries_ccn3_key" UNIQUE (ccn3), CONSTRAINT "countries_latlng_check" CHECK (((latlng[1] >= ('-90'::integer)::double precision) AND (latlng[1] <= (90)::double precision) AND (latlng[2] <= (180)::double precision) AND (latlng[2] >= ('-180'::integer)::double precision))), CONSTRAINT "countries_pkey" PRIMARY KEY (cca3), CONSTRAINT "countries_region_check" CHECK ((region = ANY (ARRAY['Africa'::text, 'Americas'::text, 'Antarctic'::text, 'Asia'::text, 'Europe'::text, 'Oceania'::text]))), CONSTRAINT "countries_subregion_check" CHECK ((subregion = ANY (ARRAY[NULL::text, 'Australia and New Zealand'::text, 'Caribbean'::text, 'Central America'::text, 'Central Asia'::text, 'Central Europe'::text, 'Eastern Africa'::text, 'Eastern Asia'::text, 'Eastern Europe'::text, 'Melanesia'::text, 'Micronesia'::text, 'Middle Africa'::text, 'North America'::text, 'Northern Africa'::text, 'Northern Europe'::text, 'Polynesia'::text, 'South America'::text, 'South-Eastern Asia'::text, 'Southern Africa'::text, 'Southern Asia'::text, 'Southern Europe'::text, 'Western Africa'::text, 'Western Asia'::text, 'Western Europe'::text]))));
ALTER TABLE "public"."countries" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public" ON "public"."countries" FOR SELECT TO PUBLIC USING (true);
COMMENT ON COLUMN "public"."countries"."cca2" IS 'ISO 3166-1 alpha-2 code.';
COMMENT ON COLUMN "public"."countries"."cca3" IS 'ISO 3166-1 alpha-3 code.';
COMMENT ON COLUMN "public"."countries"."ccn3" IS 'ISO 3166-1 numeric code.';
COMMENT ON COLUMN "public"."countries"."flag" IS 'The flag, an SVG document.';
COMMENT ON COLUMN "public"."countries"."names" IS 'Common, official and native names: {"common", "official", "native": {<language>: {"common", "official"}}}.';
COMMENT ON TABLE "public"."countries" IS 'The world''s countries: ISO 3166 codes, names, region, and flag. Reference data, loaded from supabase/seeds/countries.sql; read only.';
REVOKE ALL ON TABLE "public"."countries" FROM "anon";
GRANT SELECT ON TABLE "public"."countries" TO "anon";
REVOKE ALL ON TABLE "public"."countries" FROM "authenticated";
GRANT SELECT ON TABLE "public"."countries" TO "authenticated";
REVOKE ALL ON TABLE "public"."countries" FROM "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."countries" TO "postgres";
GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."countries" TO "service_role";
COMMIT;
