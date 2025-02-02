DB ?= ${PG}/${DB_NAME}

TIME != date +'%Y-%m-%d--%T'
DUMP = ${DB_NAME}-${TIME}-${env}.dump

SQL_FILES != cat sql-files.txt

data ?= dumps/data-latest
schema ?= dumps/schema-latest

env ?= development

list:
	@ psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

console:
	@ echo ${DB}
	@ PAGER="less -S" psql ${DB}

dumpschema:
	@ pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--schema-only \
		> dumps/schema-${DUMP}

	@ (cd dumps && ln -sf schema-${DUMP} schema-latest)

dumpdata:
	@ mkdir -p dumps

	@ pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--data-only \
		> dumps/data-${DUMP}

	@ (cd dumps && ln -sf data-${DUMP} data-latest)

disconnect:
	@ psql ${PG}/template1 --quiet --command "update pg_database set datallowconn = 'false' where datname = '${DB_NAME}';" >/dev/null
	@ psql ${PG}/template1 --quiet --command "select pg_terminate_backend(pid) from pg_stat_activity where datname = '${DB_NAME}';" >/dev/null

drop: disconnect
	@ psql ${PG}/template1 --quiet --command "drop database ${DB_NAME};"

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
		--file="${data}"

	@ echo "Restored from dumpfile: ${data}"

reload:
	@ psql ${DB} --quiet --command "NOTIFY pgrst, 'reload schema';"

.if ${env} == "production"
rebuild:
	@ echo "PRODUCTION. Do it by hand: drop create build restore reload"
.else
rebuild: drop create build restore reload
.endif
