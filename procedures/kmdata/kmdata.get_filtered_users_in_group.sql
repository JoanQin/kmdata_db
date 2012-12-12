CREATE OR REPLACE FUNCTION kmdata.get_filtered_users_in_group (
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
      SELECT DISTINCT b.user_id
      FROM structured_groups a
      INNER JOIN kmdata.user_groups b ON a.group_id = b.group_id
      WHERE b.user_id NOT IN (
         SELECT b2.user_id 
         FROM structured_groups a2
         INNER JOIN kmdata.group_excluded_users b2 ON a2.group_id = b2.group_id
         WHERE a2.group_id = ANY(path)
      );

   -- return the result
   RETURN $2;
END;
$$ LANGUAGE plpgsql;
