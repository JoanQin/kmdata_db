CREATE OR REPLACE FUNCTION kmdata.get_all_nested_groups (
   p_GroupId BIGINT,
   refcursor
) RETURNS refcursor AS $$
DECLARE
   --v_curResult refcursor;
BEGIN
   -- open the result set
   OPEN $2 FOR
      WITH RECURSIVE structured_groups(group_id, depth, path, cycle) AS (
         SELECT a.id, 1, ARRAY[a.id], false
         FROM kmdata.groups a
         WHERE a.id = p_GroupId
         UNION ALL
         SELECT a1.id, c1.depth + 1, path || a1.id, a1.id = ANY(path)
         FROM kmdata.groups a1
         INNER JOIN kmdata.user_groups_nestings b1 ON a1.id = b1.group_id
         INNER JOIN structured_groups c1 ON b1.parent_id = c1.group_id
         WHERE NOT cycle
      )
      SELECT *
      FROM structured_groups a
      INNER JOIN kmdata.groups b ON a.group_id = b.id
      ORDER BY depth ASC, path ASC;

   -- return the result
   RETURN $2;
END;
$$ LANGUAGE plpgsql;
