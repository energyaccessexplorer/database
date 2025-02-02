SQL ?= ./sql

AWK = gawk
COLORDIFF != which colordiff || which cat

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
	@ cp schema-header.sql ${schema}

	@ while read file; do \
		cat $$file >> ${schema}; \
		printf "\n\n" >> ${schema}; \
	done <${SQL}/include.txt

	@ cat schema-footer.sql >> ${schema}

	@ echo "Wrote: ${schema}"
