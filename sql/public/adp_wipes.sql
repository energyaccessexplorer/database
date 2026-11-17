-- Clears assumed destination defaults before creating objects.
-- Safe to load on a project that does not have those defaults.

alter default privileges for role "postgres" in schema "public" revoke all on sequences from "anon";

alter default privileges for role "postgres" in schema "public" revoke all on sequences from "authenticated";

alter default privileges for role "postgres" in schema "public" revoke all on sequences from "service_role";

alter default privileges for role "postgres" in schema "public" revoke all on FUNCTIONS from "anon";

alter default privileges for role "postgres" in schema "public" revoke all on FUNCTIONS from "authenticated";

alter default privileges for role "postgres" in schema "public" revoke all on FUNCTIONS from "service_role";

alter default privileges for role "postgres" in schema "public" revoke all on tables from "anon";

alter default privileges for role "postgres" in schema "public" revoke all on tables from "authenticated";

alter default privileges for role "postgres" in schema "public" revoke all on tables from "service_role";
