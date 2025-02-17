SQL ?= ./sql

AWK = gawk
COLORDIFF != which colordiff || which cat

schemajoin = ./tmp/schema-join-${TIME}.sql

split:
	@ mkdir -p ./tmp
	@ if [ -d ${SQL} ]; then cp -r ${SQL} ./tmp/${SQL}-${TIME}; fi

	${AWK} \
		-f split.awk \
		-v sqldir=${SQL} \
		${schema}

diff:
	@ diff \
		--ignore-blank-lines \
		--ignore-all-space \
		--ignore-case \
		--ignore-matching-lines='-- *' \
		${schema-left} ${schema-right} \
	| ${COLORDIFF} \
	| less -R \
	|| exit 0

join:
	@ cp schema-header.sql ${schemajoin}

	@ while read file; do \
		cat $$file >> ${schemajoin}; \
		printf "\n\n" >> ${schemajoin}; \
	done <${SQL}/include.txt

	@ cat schema-footer.sql >> ${schemajoin}

	@ echo "Wrote: ${schemajoin}"
