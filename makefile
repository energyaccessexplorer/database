default:
	psql ${DB} \
		--set="ON_ERROR_STOP=on" \
		--file="snippet.sql"

.include "./database.mk"
.include "./split.mk"

-include .env
