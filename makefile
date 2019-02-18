# PASSWD != pass username/example.org
# TIME != date +'%Y-%m-%d--%T'
#
# PG_DEV = postgres://postgres@localhost
# PG_PROD = postgres://username:${PASSWD}@example.org
#
# DBNAME = ea
# DB_DEV = ${PG_DEV}/${DBNAME}_dev
# DB_PROD = ${PG_PROD}/${DBNAME}
#
# DB = ${DB_DEV}
#
# DUMP = ${DBNAME}-${TIME}
#
# ifeq (${env},production)
# DB = ${DB_PROD}
# endif
#
# TEMPLATE1 = ${PG_DEV}/template1
#
include default.mk

default: list

console:
	@psql ${DB}

dump-data:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--no-owner \
		--data-only > dumps/${DUMP}

	@(cd dumps && ln -sf ${DUMP} latest-data)

list:
	@psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

# ONLY TO BE USED IN _dev:

drop:
	@psql ${TEMPLATE1} -c "drop   database ${DBNAME}_dev;"

create:
	@psql ${TEMPLATE1} -c "create database ${DBNAME}_dev;"

build:
	@for file in \
		db \
		countries \
		categories \
		datasets \
		files \
		grants \
		; do \
		psql ${DB_DEV} --file=sql/$$file.sql ; \
	done

restore:
	@psql ${DB_DEV} \
		-v ON_ERROR_STOP=on \
		--command="SET session_replication_role = replica;" \
		--file=./dumps/latest-data

rebuild: drop create build restore

signin:
	@psql ${DB} \
		--pset="pager=off" \
		--pset="tuples_only=on" \
		--command="select 'localStorage.setItem(\"token\", \"' || sign(row_to_json(r), '${PGREST_SECRET}') || '\");' from (select 'ea_admin' as role, extract(epoch from now())::integer + 600*60 as exp) as r"
