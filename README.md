# Energy Access Explorer Database

This is the SQL (PostgreSQL) code for the platform's database.

Naturally, PostgreSQL must be installed and running before starting.

## Dependencies

The following must also be installed on the system:

- PostgreSQL (+PostgREST) handle authentication and permissions via JWT
using [pgjwt](https://github.com/michelp/pgjwt)

- UUID's and other checksums are generated via
[pgcrypto](https://www.postgresql.org/docs/current/pgcrypto.html). Which is
generally installed with any PostgreSQL server

## Configuration

Copy the `.env-sample` to `.env` and edit it as needed.

## Building the database

If everything is set up properly, you should be able to run

	$ bmake create

without any errors. Then,

	$ bmake join build

`join` takes the source code and builds and creates a schema "dump file" which
is then used by `build`.

(optional) Provided a data dump `the-dump.sql`, place it under the `dumps/`
directory and run

	$ bmake restore data=dumps/the-dump.sql

## Development

The main idea is to be able to make changes and quickly rebuild/restore the
database.

### Flow 1: `psql`

- `bmake console`
- changes...
- `bmake dumpschema split`

### Flow 2: `snippet.sql`

- edit `snippet.sql`
- `bmake snippet`
- ... repeat.
- `bmake dumpschema split`

### Flow 3: source code

- edit the necessary files in `sql/`
- `bmake rebuild dumpschema split`
