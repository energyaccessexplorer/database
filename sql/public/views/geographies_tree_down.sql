create view "public"."geographies_tree_down" AS  WITH RECURSIVE tree AS (
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
 SELECT id,
    path
   FROM tree
  ORDER BY (array_length(path, 1));

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies_tree_down" to "anon", "authenticated";

revoke all on table "public"."geographies_tree_down" from "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies_tree_down" to "postgres";

grant delete, insert, maintain, references, select, trigger, truncate, update on table "public"."geographies_tree_down" to "service_role";
