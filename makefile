include ../default.mk

DB = ${PG}/${DB_NAME}

TEMPLATE1 = ${PG}/template1

TIME != date +'%Y-%m-%d--%T'
DUMP = ${DB_NAME}-${TIME}-${env}.dump

.ifndef dump
dump = dumps/latest-data
.endif

default: show

show:
	@echo "DUMP: ${dump} -> ${DUMP}"
	@echo "DB: ${DB}"

console:
	@psql ${DB}

dump-schema:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--schema-only > dumps/${DUMP}-schema

	@(cd dumps && ln -sf ${DUMP}-schema latest-schema)

dump-data:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--data-only > dumps/${DUMP}-data

	@(cd dumps && ln -sf ${DUMP}-data latest-data)

list:
	@psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

drop:
	psql ${TEMPLATE1} -c "drop database ${DB_NAME};"

create:
	psql ${TEMPLATE1} -c "create database ${DB_NAME};"

build:
	@echo ${DB}

	@for file in ${SQL_FILES}; do \
		psql ${DB} --file=sql/$$file.sql ; \
	done

restore:
	@psql ${DB} \
		-v ON_ERROR_STOP=on \
		--command="SET session_replication_role = replica;" \
		--file=${dump}

	@echo "Restored from dumpfile: ${dump}"

rebuild: drop create build restore

snippet:
	@psql ${DB} \
		--pset="pager=off" \
		--file=./snippet.sql

-include extras.mk
