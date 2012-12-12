CREATE OR REPLACE FUNCTION kmdata.import_buildings_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT a.bldg_cd AS building_code,
         a.descr AS name, a.descrshort AS name_abbrev,
         b.name AS curr_name, b.name_abbrev AS curr_name_abbrev 
      FROM sid.ps_bldg_tbl a
      INNER JOIN kmdata.buildings b ON a.bldg_cd = b.building_code;
   
   v_InsertCursor CURSOR FOR
      SELECT chgbldg.building_code, a.descr AS name, a.descrshort AS name_abbrev
      FROM
      (
         SELECT ai.bldg_cd AS building_code
           FROM sid.ps_bldg_tbl ai
         EXCEPT
         SELECT x.building_code
           FROM kmdata.buildings x
      ) chgbldg
      INNER JOIN sid.ps_bldg_tbl a ON chgbldg.building_code = a.bldg_cd;
      
   v_BuildingsUpdated INTEGER;
   v_BuildingsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   SELECT id
   INTO v_CampusID
   FROM kmdata.campuses
   WHERE campus_name = 'Columbus';

   v_BuildingsUpdated := 0;
   v_BuildingsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here
   DELETE FROM kmdata.buildings bd
   WHERE NOT EXISTS (
      SELECT a.bldg_cd
      FROM sid.ps_bldg_tbl a
      WHERE a.bldg_cd = bd.building_code
   );

   -- Step 2: update
   FOR v_updBuilding IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updBuilding.name != v_updBuilding.curr_name
         OR v_updBuilding.name_abbrev != v_updBuilding.curr_name_abbrev
      THEN
      
         -- update the record
         UPDATE kmdata.buildings
            SET name = v_updBuilding.name,
                name_abbrev = v_updBuilding.curr_name_abbrev,
                campus_id = v_CampusID
	        --updated_at = current_timestamp
          WHERE building_code = v_updBuilding.building_code
            AND campus_id = v_CampusID;

         v_BuildingsUpdated := v_BuildingsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insBuilding IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.buildings (
	 name, building_code, name_abbrev, campus_id, resource_id)
      VALUES (
         v_insBuilding.name, v_insBuilding.building_code, v_insBuilding.name_abbrev, v_CampusID, kmdata.add_new_resource('sid', 'buildings'));

      v_BuildingsInserted := v_BuildingsInserted + 1;

   END LOOP;


   v_ReturnString := 'Buildings import completed. ' || CAST(v_BuildingsUpdated AS VARCHAR) || ' buildings updated and ' || CAST(v_BuildingsInserted AS VARCHAR) || ' buildings inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
