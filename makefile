default:
	psql ${DB} --file="snippet.sql"

.include "./database.mk"

-include .env
