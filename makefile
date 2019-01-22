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

dump:
	@pg_dump ${DB} \
		--verbose \
		--format=p \
		--data-only \
		--no-owner > dumps/${DUMP}

	@(cd dumps && ln -sf ${DUMP} latest)

list:
	@psql ${DB} \
		--pset="pager=off" \
		--command="\dt[+]"

# ONLY TO BE USED IN _dev:

drop:
	@psql ${TEMPLATE1} -c "drop   database ${DBNAME}_dev;"

create:
	@psql ${TEMPLATE1} -c "create database ${DBNAME}_dev;"

restore:
	@psql ${DB_DEV} \
		-v ON_ERROR_STOP=on \
		--command="SET session_replication_role = replica;" \
		--file=./dumps/latest

build:
	@for file in db countries categories datasets files grants; do \
		psql ${DB_DEV} --file=sql/$$file.sql ; \
	done

rebuild: drop create build restore
