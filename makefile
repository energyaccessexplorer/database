default:
	psql ${DB} \
		--set="ON_ERROR_STOP=on" \
		--file="snippet.sql"

.include "./split.mk"
.include "./database.mk"

-include .env
