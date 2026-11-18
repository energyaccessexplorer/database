# Energy Access Explorer Database

The schema of the platform's database, hosted on Supabase.

- `sql/` declares the schema: one file per table, function, view and schema,
  with grants, policies, triggers and ownership next to the object they belong
  to. It is the file you edit. The layout is
  [pg-delta](https://github.com/supabase/pg-toolbelt/tree/main/packages/pg-delta)'s
  export format; `sql/.pgdelta-export.json` records the default owner
  (`postgres`) and load order.
- `supabase/migrations/` holds the versioned changes that take a database to
  that schema. They are generated from `sql/`, reviewed, committed, and never
  edited once merged.
- `supabase/platform.sql` holds the roles, schemas and default privileges
  shared by every local database, whatever provisions the rest of the
  platform. `supabase/platform-stub.sql` adds a hand-written `auth` stub for
  CI, where no real platform command runs. The root flake's
  `supabase-platform` command takes that further on a dev machine: GoTrue and
  Storage migrations plus the public buckets, exactly what Supabase Cloud
  provides before any user migration. None of it is ever pushed.

Everything runs through `db`, packaged by this repository's flake
(`nix run .#db -- help`, or `db` in the root EAE devShell). It needs no Docker:
local databases live on the dev cluster (`localhost:5432`).

## Changing the schema

	$ $EDITOR sql/public/tables/datasets.sql
	$ db migration new add_dataset_licence
	$ db migration up

`migration new` builds a scratch database from the existing migrations,
compares it with `sql/` and writes the difference to
`supabase/migrations/<timestamp>_<name>.sql`. Read it before committing it:
renames show up as a drop and an add, and data changes are never generated.
For those, `db migration new <name> --empty` writes a blank migration to fill
in by hand, with `sql/` edited to match.

Commit `sql/` and the migration together; `db schema check` fails when they
disagree.

## Commands

	db migration new <name> [--empty]
	db migration up | down [n] | status
	db schema check | drift | export | lint
	db reset
	db console

`DB_URL` selects the target database (the local `eae_supabase` by default).
`migration down` and `reset` only touch local databases.

## Deploying

	$ DB_URL='postgresql://postgres.<ref>:<password>@<pooler-host>:5432/postgres' db schema drift
	$ DB_URL='…' db migration up

`schema drift` fails when the target was changed outside the migrations.
`migration up` shows the pending migrations and asks before applying them;
set `DB_YES=1` where nothing can answer the prompt. Supabase reloads
PostgREST's schema cache on DDL by itself.

The host is the session-mode pooler (`aws-0-<region>.pooler.supabase.com:5432`),
not `db.<ref>.supabase.co`: that name resolves to IPv6 only, which GitHub
runners and some networks do not have. Percent-encode the password in the URL
— the CLI rejects `{}`, `;`, `,`, `&` and `\` in the userinfo.
