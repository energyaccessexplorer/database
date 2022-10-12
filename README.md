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

You should configure the first lines of the `makefile` to your needs.

## Building the database

If everythingis set up properly, you chould be able to run

	$ bmake dbcreate dbbuild
