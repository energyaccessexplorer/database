--
-- Name: geographies_tree_up; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.geographies_tree_up AS
 WITH RECURSIVE tree AS (
         SELECT geographies.id,
            geographies.parent_id,
            ARRAY[geographies.id] AS path
           FROM public.geographies
          WHERE (geographies.parent_id IS NULL)
        UNION ALL
         SELECT c.id,
            c.parent_id,
            array_append(t.path, c.id) AS array_append
           FROM (public.geographies c
             JOIN tree t ON ((t.id = c.parent_id)))
        )
 SELECT id,
    path
   FROM tree;
