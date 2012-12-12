-- NOTE: SHOULD LOCATION BE A RESOURCE???
CREATE OR REPLACE FUNCTION kmdata.fix_duplicate_location_names (
) RETURNS BIGINT AS $$
DECLARE

   DupLocationCursor CURSOR FOR
      SELECT b.name AS TypeName, b.id AS location_type_id, a.name AS ItemName, COUNT(*) AS TOTAL
      FROM kmdata.locations a INNER JOIN kmdata.location_types b ON a.location_type_id = b.id
      GROUP BY b.name, b.id, a.name
      HAVING COUNT(*) > 1;

   v_ReturnValue INTEGER := 0;
BEGIN
   -- loop through the cursor
   FOR currLocation IN DupLocationCursor LOOP

      -- update all locations for this match (kmdata.work_locations)
      UPDATE kmdata.work_locations
         SET location_id = (SELECT MIN(id) FROM kmdata.locations WHERE location_type_id = currLocation.location_type_id AND name = currLocation.ItemName)
         WHERE location_id IN (SELECT id FROM kmdata.locations WHERE location_type_id = currLocation.location_type_id AND name = currLocation.ItemName);

      -- delete the orphaned locations
      DELETE FROM kmdata.locations
         WHERE location_type_id = currLocation.location_type_id
         AND name = currLocation.ItemName
         AND id != (SELECT MIN(id) FROM kmdata.locations WHERE location_type_id = currLocation.location_type_id AND name = currLocation.ItemName);
      
   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
