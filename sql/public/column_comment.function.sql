--
-- Name: column_comment(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.column_comment(scm text, tbl text) RETURNS TABLE(comment text, name text)
    LANGUAGE sql IMMUTABLE
    AS $$
	select col_description((table_schema||'.'||table_name)::regclass::oid, ordinal_position)
		as column_comment
		, table_name::text
	from information_schema.columns
	where table_schema = scm
	and table_name = tbl;
$$;
