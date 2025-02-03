function trimline(str) {
	gsub(/[ \t]+$/, "", str)

	return str
}

function trimblock(str) {
	gsub(/^[ \t\r\n]+/, "", str)
	gsub(/[ \t\r\n]+$/, "", str)

	return str
}

function gencode() {
	if (file == "") {
		print name
		exit 1
	}

	cmd = "grep " file " " include_txt
	while ((cmd | getline result) > 0) {
		exists = result
	}
	close(cmd)

	if (exists != "") {
		print "OVERLOADED FUNCTION? " file
		exists = ""
		content = "\n\n" content
	}

	print file >> include_txt

	if (index(modified, gensub(/\.\//, "", "g", file)) > 0) {
		modified_list = file "\n" modified_list
		return
	}

	print content > file
}

function finish_block() {
	content = trimblock(content)

	system("mkdir -p " filepath)

	filename = gensub(/\(.*\)$/, "", "g", name)
	gsub(/ /, "-", filename)

	if (type == "ACL") {
		filename = gensub(/^TABLE-(.*)/, "\\1.table-acl", 1, filename)
		filename = gensub(/^SCHEMA-(.*)/, "\\1.schema-acl", 1, filename)
	} else {
		filename = filename "." tolower(gensub(/ /, "-", "g", type))
	}

	file = filepath "/" filename ".sql"

	in_block = 0

	for (i in ignored_blocks) {
		if (ignored_blocks[i] == name ":" type) {
			print "IGNORING: " name " " type
			return
		}
	}

	gencode()
}

function include_summary() {
	additions = sqldir "/.tmp/additions"
	removals = sqldir "/.tmp/removals"
	filesdiff = sqldir "/.tmp/files-diff"

	system("git diff --unified=0 " include_txt " | grep -Po '(?<=^\\+)(?!\\+\\+).*' | sort > " additions)
	system("git diff --unified=0 " include_txt " | grep -Po '(?<=^\\-)(?!\\-\\-).*' | sort > " removals)

	system("diff " additions " " removals " > " filesdiff)

	cmd = "cat " filesdiff " | grep -E '^<'"
	while ((cmd | getline result) > 0) {
		left = result "\n" left
	}
	close(cmd)

	cmd = "cat " filesdiff " | grep -E '^>'"
	while ((cmd | getline result) > 0) {
		right = result "\n" right
	}
	close(cmd)

	if (modified_list != "") {
		print "\nMODIFIED in your working tree: (I will NOT overwrite)"
		print modified_list
	}

	if (left != "") {
		print "NEW FILES:"
		print left
	}

	if (right != "") {
		print "CONSIDER DELETING:"
		print right
	}
}

BEGIN {
	name    = ""
	type    = ""
	schema  = ""
	content = ""
	table   = ""
	toc     = 0

	filepath = ""

	in_block = 0
	block_count = 0

	file_count = 0
	modified_list = ""

	include_txt = sqldir "/include.txt"

	"paste -s -d ',' split-ignored-blocks.txt" | getline ignored_blocks_string
	split(ignored_blocks_string, ignored_blocks, ",")

	system("mkdir -p " sqldir "/.tmp/")
	system("truncate -s 0 " include_txt)

	"git status --porcelain --null sql" | getline modified

	if (sqldir == "") {
		print "'sqldir' argument missing! Lookie:\n\t awk -v sqldir=<somewhere> -f this.awk some-schema.sql"
		exit 1
	}
}

/^-- Name: [^;]+; Type: [^;]+; Schema: [^;]+;/ {
	if (content) { # the previous one
		finish_block()
	}

	in_block = 1
	block_count++

	name    = gensub(/^-- Name: ([^;]+); .*$/,   "\\1", "g")
	type    = gensub(/^.* Type: ([^;]+); .*$/,   "\\1", "g")
	schema  = gensub(/^.* Schema: ([^;]+); .*$/, "\\1", "g")
	content = ""
	table   = ""

	if (schema == "-" || type == "SCHEMA" || type == "EXTENSION" || type == "COMMENT") {
		schema = "global"
	}

	filepath = sqldir "/" schema

	content = "--\n" $0 "\n--" # we've ignored these comment lines (below in the next block...)

	if (name ~ /[^,] /) {
		split(name, a, " ")
		table = a[1]
	}

	if (a[3]) {
		print "Too many spaces in name: '" name "'"
		print "This should NOT happen. We missed something."
		exit 1
	}

	next
}

in_block &&
!/^--$/ &&
!/^SET default_table_access_method/ &&
!/^SET default_tablespace/ &&
!/^-- PostgreSQL database dump complete/ {
	if (content == "") {
		content = $0
	} else {
		content = trimline(content) "\n" $0
	}
}

/^-- PostgreSQL database dump complete/ {
	finish_block()
	exit
}

END {
	include_summary()

	system("rm -rf " sqldir "/.tmp/")

	print "\n" block_count " SQL blocks processed"

	cmd = "wc -l " include_txt " | cut -f 1 -d ' '"
	while ((cmd | getline result) > 0) {
		file_count = result
	}
	close(cmd)

	if (file_count != block_count) {
		print file_count " SQL files in " include_txt
	}
}
