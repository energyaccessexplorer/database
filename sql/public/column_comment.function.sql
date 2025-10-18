--
-- Name: column_comment(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.column_comment(scm text, tbl text, col text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
	with comments as (
		select
			table_schema,
			table_name,
			column_name,
			col_description((table_schema||'.'||table_name)::regclass::oid, ordinal_position) as comment
			from information_schema.columns
			where table_name = tbl and table_schema = scm
	)
	select comment from comments where column_name = col;
$$;
