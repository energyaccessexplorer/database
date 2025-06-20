--
-- Name: geographies_tree_down; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographies_tree_down AS
 WITH RECURSIVE tree AS (
         SELECT geographies.id,
            geographies.parent_id,
            ARRAY[geographies.id] AS path
           FROM public.geographies
        UNION ALL
         SELECT c.id,
            c.parent_id,
            array_prepend(c.id, t.path) AS array_prepend
           FROM (public.geographies c
             JOIN tree t ON ((c.id = t.parent_id)))
        )
 SELECT tree.id,
    tree.path
   FROM tree
  ORDER BY (array_length(tree.path, 1));
