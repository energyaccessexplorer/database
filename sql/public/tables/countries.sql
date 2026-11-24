create table "public"."countries" (
  "cca3"        character varying(3)   not null,
  "cca2"        character varying(2),
  "ccn3"        character varying(3),
  "names"       jsonb,
  "name"        text                   generated always as ((names ->> 'common'::text)) stored,
  "tld"         text[],
  "independent" boolean,
  "un_member"   boolean,
  "currencies"  jsonb,
  "capital"     text,
  "phonecodes"  text[],
  "region"      text,
  "subregion"   text,
  "latlng"      double precision[],
  "lnglat"      double precision[]     generated always as (ARRAY[latlng[2], latlng[1]]) stored,
  "landlocked"  boolean,
  "borders"     character varying(3)[],
  "area"        integer,
  "flag"        bytea,
  constraint "countries_cca2_key" unique (cca2),
  constraint "countries_ccn3_check" check (((ccn3)::text ~ '[0-9]{3}'::text)),
  constraint "countries_ccn3_key" unique (ccn3),
  constraint "countries_latlng_check"
    check
    (((latlng[1] >= ('-90'::integer)::double precision) AND (latlng[1] <= (90)::double precision) AND (latlng[2] <= (180)::double precision) AND (latlng[2] >=
    ('-180'::integer)::double precision))),
  constraint "countries_pkey" primary key (cca3),
  constraint "countries_region_check" check ((region = ANY (ARRAY['Africa'::text, 'Americas'::text, 'Antarctic'::text, 'Asia'::text, 'Europe'::text, 'Oceania'::text]))),
  constraint "countries_subregion_check"
    check
    ((subregion = ANY (ARRAY[NULL::text, 'Australia and New Zealand'::text, 'Caribbean'::text, 'Central America'::text, 'Central Asia'::text, 'Central Europe'::text,
    'Eastern Africa'::text,
    'Eastern Asia'::text,
    'Eastern Europe'::text,
    'Melanesia'::text,
    'Micronesia'::text,
    'Middle Africa'::text,
    'North America'::text,
    'Northern Africa'::text,
    'Northern Europe'::text,
    'Polynesia'::text,
    'South America'::text,
    'South-Eastern Asia'::text, 'Southern Africa'::text, 'Southern Asia'::text, 'Southern Europe'::text, 'Western Africa'::text, 'Western Asia'::text, 'Western Europe'::text])))
);

alter table "public"."countries"
  enable row level security;

create policy "public" on "public"."countries"
  for select
  to PUBLIC
  using (true);

comment on column "public"."countries"."cca2" is 'ISO 3166-1 alpha-2 code.';

comment on column "public"."countries"."cca3" is 'ISO 3166-1 alpha-3 code.';

comment on column "public"."countries"."ccn3" is 'ISO 3166-1 numeric code.';

comment on column "public"."countries"."flag" is 'The flag, an SVG document.';

comment on column "public"."countries"."names" is 'Common, official and native names: {"common", "official", "native": {<language>: {"common", "official"}}}.';

comment on table "public"."countries" is 'The world''s countries: ISO 3166 codes, names, region, and flag. Reference data, loaded from supabase/seeds/countries.sql; read only.';

revoke all on table "public"."countries" from "anon";

grant select on table "public"."countries" to "anon";

revoke all on table "public"."countries" from "authenticated";

grant select on table "public"."countries" to "authenticated";

revoke all on table "public"."countries" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."countries" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."countries" to "service_role";
