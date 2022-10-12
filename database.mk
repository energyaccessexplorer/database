DB = ${PG}/${DB_NAME}

TIME != date +'%Y-%m-%d--%T'
DUMP = ${DB_NAME}-${TIME}-${env}.dump

SQL_FILES != cat sql-files.txt

.ifndef dump
dump = dumps/latest-data
.endif

dblist:
	@psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

dbconsole:
	PAGER="less -S" psql ${DB}

dbdumpschema:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--schema-only > dumps/${DUMP}-schema

	@(cd dumps && ln -sf ${DUMP}-schema latest-schema)

dbdumpdata:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--data-only > dumps/${DUMP}-data

	@(cd dumps && ln -sf ${DUMP}-data latest-data)

dbdrop:
	psql ${PG}/template1 -q -c "update pg_database set datallowconn = 'false' where datname = '${DB_NAME}';"
	psql ${PG}/template1 -q -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = '${DB_NAME}';" >/dev/null
	psql ${PG}/template1 -q -c "drop database ${DB_NAME};"

dbcreate:
	psql ${PG}/template1 -q -c "create database ${DB_NAME};"

dbbuild:
	@echo ${DB}

	@for file in ${SQL_FILES}; do \
		psql ${DB} -v ON_ERROR_STOP=on --file=$$file.sql  >/dev/null; \
	done

dbrestore:
	@psql ${DB} \
		-P tuples_only=on \
		-v ON_ERROR_STOP=on \
		--command="set session_replication_role = replica;" \
		--file=${dump}

	@echo "Restored from dumpfile: ${dump}"

.if ${env} == "production"
dbrebuild:
	@echo "PRODUCTION. Do it by hand: dbdrop dbcreate dbbuild dbrestore"
.else
dbrebuild: dbdrop dbcreate dbbuild dbrestore
.endif
