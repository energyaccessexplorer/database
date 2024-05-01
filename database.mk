DB = ${PG}/${DB_NAME}

TIME != date +'%Y-%m-%d--%T'
DUMP = ${DB_NAME}-${TIME}-${env}.dump

SQL_FILES != cat sql-files.txt

.ifndef dump
dump = dumps/latest-data
.endif

.ifdef db
DB = ${db}
.else
.endif

list:
	@ psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

console:
	echo ${DB}
	@ PAGER="less -S" psql ${DB}

dumpschema:
	@ pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--schema-only \
		> dumps/${DUMP}-schema

	@ (cd dumps && ln -sf ${DUMP}-schema latest-schema)

dumpdata:
	@ pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--data-only \
		> dumps/${DUMP}-data

	@ (cd dumps && ln -sf ${DUMP}-data latest-data)

drop:
	@ psql ${PG}/template1 --quiet \
		--command "update pg_database set datallowconn = 'false' where datname = '${DB_NAME}';" \
		--command "select pg_terminate_backend(pid) from pg_stat_activity where datname = '${DB_NAME}';" \
		--command "drop database ${DB_NAME};" \
		> /dev/null

create:
	@ psql ${PG}/template1 --quiet --command "create database ${DB_NAME};"

build:
	@ for file in ${SQL_FILES}; do \
		psql ${DB} \
			--set="ON_ERROR_STOP=on" \
			--file="$$file.sql" >/dev/null; \
	done

restore:
	@ psql ${DB} \
		--set="ON_ERROR_STOP=on" \
		--pset="tuples_only=on" \
		--command="set session_replication_role = replica;" \
		--file="${dump}"

	@ echo "Restored from dumpfile: ${dump}"

reload:
	@ psql ${DB} --quiet --command "NOTIFY pgrst, 'reload schema';"

.if ${env} == "production"
rebuild:
	@ echo "PRODUCTION. Do it by hand: drop create build restore reload"
.else
rebuild: drop create build restore reload
.endif
