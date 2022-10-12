DB_NAME = ea_dev
PG = postgres://postgres@localhost

default:
	psql ${DB} --pset="pager=off" --file=snippet.sql

.include <database.mk>
