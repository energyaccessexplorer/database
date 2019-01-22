# Energy Access Explorer Database

This is the SQL code to setup the database and some minor utilities (in the
`makefile`).

It is written in PostgreSQL with a PostgREST API in front it. Hence, the
external dependencies/extensions must be pre-installed on the system:
- [pgjwt](https://github.com/michelp/pgjwt)
- [uri](https://github.com/petere/pguri)
