left ?= dumps/schema-latest
right ?= dumps/join-latest

SQL = ./sql
TIME != date +'%Y-%m-%d--%T'
OS != uname -s

AWK = gawk
.if ${OS} == "Darwin"
AWK != which gawk || /opt/homebrew/bin/gawk
.endif

join = schema-join-${TIME}.sql

diff:
	@ diff \
		--ignore-blank-lines \
		--ignore-all-space \
		--ignore-case \
		--ignore-matching-lines='-- *' \
		${left} ${right} \
	| less -R \
	|| exit 0

	@ echo "Comparing ${left} and ${right}"

split:
	${AWK} \
		-f split/split.awk \
		-v sqldir=${SQL} \
		${schema}

join:
	@ cp split/schema-header.sql dumps/${join}

	@ while read file; do \
		cat $$file >> dumps/${join}; \
		printf "\n\n" >> dumps/${join}; \
	done <${SQL}/include.txt

	@ cat split/schema-footer.sql >> dumps/${join}

	@ (cd dumps && ln -sf ${join} schema-latest)

	@ echo "Wrote: dumps/${join} (schema-latest)"

.PHONY: split
