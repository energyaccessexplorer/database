# db — the EAE database schema and its migrations.
#
# sql/ declares the schema the database should have (pg-delta's export
# layout). supabase/migrations/ holds the versioned changes that take a
# database there; they are applied with the Supabase CLI and recorded in
# supabase_migrations.schema_migrations, locally and on Supabase alike.
#
# Local databases live on the dev cluster (DB_LOCAL) and start from
# supabase/platform.sql, which stands in for what Supabase Cloud provides.
# Scratch databases used for comparisons are created there and dropped on exit.

DB_LOCAL=${DB_LOCAL:-localhost:5432}
DB_NAME=${DB_NAME:-eae_supabase}
DB_URL=${DB_URL:-postgresql://postgres@$DB_LOCAL/$DB_NAME}

export DO_NOT_TRACK=1
export PGOPTIONS="-c client_min_messages=warning"

usage() {
	cat <<'EOF'
usage: db <command> [args]

  migration new <name> [--empty]  write supabase/migrations/<timestamp>_<name>.sql
                                  with what sql/ adds to the existing migrations;
                                  --empty writes a blank one (data changes)
  migration up                    apply pending migrations to DB_URL
  migration down [n]              rebuild the local database without the last n
                                  applied migrations (default 1); its data is lost
  migration status                applied and pending migrations on DB_URL

  schema check                    fail unless the migrations produce exactly sql/
  schema drift                    fail unless DB_URL matches the migrations
  schema export                   rewrite sql/ from DB_URL
  schema lint                     static load-order checks on sql/

  reset                           recreate the local database from the migrations
  console                         psql on DB_URL

environment:
  DB_LOCAL  dev cluster host:port   (localhost:5432)
  DB_NAME   local database          (eae_supabase)
  DB_URL    target database        (postgresql://postgres@$DB_LOCAL/$DB_NAME)
  DB_YES    set to apply to a remote DB_URL without asking
EOF
}

die() {
	echo "db: $*" >&2
	exit 1
}

find_root() {
	local dir=$PWD
	while [ "$dir" != / ]; do
		if [ -f "$dir/sql/.pgdelta-export.json" ]; then
			echo "$dir"
			return
		fi
		if [ -f "$dir/database/sql/.pgdelta-export.json" ]; then
			echo "$dir/database"
			return
		fi
		dir=$(dirname "$dir")
	done
	die "no database checkout at or above $PWD"
}

local_url() {
	echo "postgresql://postgres@$DB_LOCAL/$1"
}

is_local() {
	case $1 in
		"postgresql://postgres@$DB_LOCAL/"*) return 0 ;;
		*) return 1 ;;
	esac
}

require_local() {
	is_local "$DB_URL" || die "$1 only runs against the local cluster, not $DB_URL"
}

database_of() {
	local url=${1%%\?*}
	echo "${url##*/}"
}

admin() {
	psql "postgresql://$DB_LOCAL/postgres" -X -q -v ON_ERROR_STOP=1 "$@"
}

create_local() {
	admin -c "do \$\$ begin
		if not exists (select from pg_roles where rolname = 'postgres') then
			create role postgres superuser login;
		end if;
	end \$\$" -c "create database \"$1\" owner postgres"
	local url
	url=$(local_url "$1")
	if [ -n "${DB_PLATFORM:-}" ]; then
		"$DB_PLATFORM" "$url"
	else
		psql "$url" -X -q -v ON_ERROR_STOP=1 \
			-f "$ROOT/supabase/platform.sql" \
			-f "$ROOT/supabase/platform-stub.sql"
	fi
}

drop_local() {
	admin -c "drop database if exists \"$1\" with (force)"
}

local_exists() {
	[ -n "$(admin -Atc "select 1 from pg_database where datname = '$1'")" ]
}

migration_files() {
	find "$ROOT/supabase/migrations" -maxdepth 1 -name '*.sql' | sort
}

# Applies the first $2 migrations (all when empty) to $1.
push() {
	local url=$1 count=${2:-} workdir=$ROOT
	if [ -n "$count" ]; then
		workdir="$TMP/push-$count"
		mkdir -p "$workdir/supabase/migrations"
		cp "$ROOT/supabase/config.toml" "$workdir/supabase/"
		migration_files | head -n "$count" | xargs -I{} cp {} "$workdir/supabase/migrations/"
	fi
	if is_local "$url"; then
		PGSSLMODE=disable supabase db push --db-url "$url" --workdir "$workdir" --yes
	elif [ -n "${DB_YES:-}" ]; then
		supabase db push --db-url "$url" --workdir "$workdir" --yes
	else
		supabase db push --db-url "$url" --workdir "$workdir"
	fi
}

SCRATCH=()
SCRATCH_URL=

# A scratch database with the first $1 migrations (all when empty) applied.
scratch() {
	local name="eae_scratch_$$_${#SCRATCH[@]}"
	SCRATCH+=("$name")
	create_local "$name"
	SCRATCH_URL=$(local_url "$name")
	if ! push "$SCRATCH_URL" "${1:-}" >"$TMP/push.log" 2>&1; then
		cat "$TMP/push.log" >&2
		die "migrations failed to apply to a scratch database"
	fi
}

cleanup() {
	local name
	for name in "${SCRATCH[@]}"; do
		drop_local "$name" >/dev/null 2>&1 || true
	done
	rm -rf "$TMP"
}

plan_sql() {
	pgdelta schema apply --dir "$ROOT/sql" --target "$1" --profile supabase --dry-run
}

migration_new() {
	local name=${1:-} empty=${2:-}
	[[ $name =~ ^[a-z0-9_]+$ ]] || die "migration name must match [a-z0-9_]+"
	local file
	file="$ROOT/supabase/migrations/$(date -u +%Y%m%d%H%M%S)_$name.sql"
	if [ "$empty" = --empty ]; then
		: >"$file"
		echo "$file"
		return
	fi
	[ -z "$empty" ] || die "unknown option $empty"
	scratch
	plan_sql "$SCRATCH_URL" >"$TMP/plan.sql"
	if [ ! -s "$TMP/plan.sql" ]; then
		echo "sql/ matches the migrations; no migration written" >&2
		return
	fi
	mv "$TMP/plan.sql" "$file"
	echo "$file"
}

migration_up() {
	if is_local "$DB_URL" && ! local_exists "$(database_of "$DB_URL")"; then
		create_local "$(database_of "$DB_URL")"
	fi
	push "$DB_URL"
}

migration_down() {
	local n=${1:-1}
	require_local "migration down"
	[[ $n =~ ^[0-9]+$ ]] || die "migration down takes a count"
	local applied
	applied=$(applied_count)
	[ "$n" -le "$applied" ] || die "only $applied migrations are applied"
	local name
	name=$(database_of "$DB_URL")
	drop_local "$name"
	create_local "$name"
	if [ $((applied - n)) -gt 0 ]; then
		push "$DB_URL" $((applied - n))
	fi
}

migration_status() {
	if is_local "$DB_URL"; then
		PGSSLMODE=disable supabase migration list --db-url "$DB_URL" --workdir "$ROOT"
	else
		supabase migration list --db-url "$DB_URL" --workdir "$ROOT"
	fi
}

schema_check() {
	scratch
	plan_sql "$SCRATCH_URL" >"$TMP/plan.sql"
	if [ -s "$TMP/plan.sql" ]; then
		cat "$TMP/plan.sql"
		die "sql/ differs from what the migrations produce; run: db migration new <name>"
	fi
	echo "sql/ matches the migrations"
}

applied_count() {
	psql "$DB_URL" -X -Atc "select count(*) from supabase_migrations.schema_migrations" 2>/dev/null || echo 0
}

schema_drift() {
	scratch "$(applied_count)"
	pgdelta snapshot --source "$SCRATCH_URL" --out "$TMP/migrations.snapshot" --profile supabase >/dev/null
	pgdelta drift --env "$DB_URL" --snapshot "$TMP/migrations.snapshot" --profile supabase
}

schema_export() {
	pgdelta schema export --source "$DB_URL" --out-dir "$ROOT/sql" --profile supabase --strict-coverage
}

schema_lint() {
	pgdelta schema lint --dir "$ROOT/sql"
}

reset() {
	require_local reset
	local name
	name=$(database_of "$DB_URL")
	drop_local "$name"
	create_local "$name"
	push "$DB_URL"
}

ROOT=$(find_root)
TMP=$(mktemp -d)
trap cleanup EXIT

case "${1:-} ${2:-}" in
	"migration new") shift 2; migration_new "$@" ;;
	"migration up") migration_up ;;
	"migration down") shift 2; migration_down "$@" ;;
	"migration status") migration_status ;;
	"schema check") schema_check ;;
	"schema drift") schema_drift ;;
	"schema export") schema_export ;;
	"schema lint") schema_lint ;;
	"reset "*) reset ;;
	"console "*) psql "$DB_URL" ;;
	*) usage; [ "${1:-}" = help ] || [ -z "${1:-}" ] || exit 1 ;;
esac
