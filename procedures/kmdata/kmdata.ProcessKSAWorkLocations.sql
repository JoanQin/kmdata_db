CREATE OR REPLACE FUNCTION kmdata.ProcessKSAWorkLocations (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;

   v_intLocationTypesCount BIGINT;
   v_intKSALocationType BIGINT;
   v_intLocationsCount BIGINT;
   v_intLocationID BIGINT;

   ArchWorksCursor CURSOR FOR
      SELECT a.work_id, a.location_nid, b.id AS ksa_location_id, b.latitude_value, b.longitude_value
      FROM kmdata.work_arch_details a
      INNER JOIN kmdata.locations_ksa b ON a.location_nid = b.nid;
BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   -- check the types count
   SELECT COUNT(*) INTO v_intLocationTypesCount
   FROM kmdata.location_types
   WHERE name = 'KSA Location Resource';
   IF v_intLocationTypesCount = 0 THEN
      INSERT INTO kmdata.location_types
         (name, created_at, updated_at)
      VALUES
         ('KSA Location Resource', current_timestamp, current_timestamp);
   END IF;

   -- get the type
   SELECT id INTO v_intKSALocationType FROM kmdata.location_types WHERE name = 'KSA Location Resource';

   -- loop over the cursor
   FOR currWork IN ArchWorksCursor LOOP

      -- look for a match in the ref table
      SELECT COUNT(*) INTO v_intLocationsCount
      FROM kmdata.locations
      WHERE location_type_id = v_intKSALocationType
      AND latitude = currWork.latitude_value
      AND longitude = currWork.longitude_value;

      IF v_intLocationsCount = 1 THEN
      
         -- select the location ID
         SELECT id INTO v_intLocationID
         FROM kmdata.locations
         WHERE location_type_id = v_intKSALocationType
         AND latitude = currWork.latitude_value
         AND longitude = currWork.longitude_value;

         -- insert if the record doesn't exist
         BEGIN
            INSERT INTO kmdata.work_locations
               (work_id, location_id)
            VALUES
               (currWork.work_id, v_intLocationID);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
      ELSIF v_intLocationsCount = 0 THEN

         -- get the sequence ID
         v_intLocationID := nextval('kmdata.locations_id_seq');

         -- insert the record
         INSERT INTO kmdata.locations
            (id, location_type_id, created_at, updated_at, latitude, longitude)
         VALUES
            (v_intLocationID, v_intKSALocationType, current_timestamp, current_timestamp, currWork.latitude_value, currWork.longitude_value);

         -- insert the record
         INSERT INTO kmdata.work_locations
            (work_id, location_id)
         VALUES
            (currWork.work_id, v_intLocationID);
      ELSE
      
         -- multiple locations records exist for this type/lat./long., error
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('KSA Locations/Work Locations SELECT error (non-single match): ' || 
                 CAST(v_intLocationsCount AS CHAR) || ' locations records matched location_type==[' || CAST(v_intKSALocationType AS CHAR) || '] latitude==[' || 
                 CAST(currWork.latitude_value AS CHAR) || '], longitude==[' || CAST(currWork.longitude_value AS CHAR) || ']. Record skipped.'
         );
            
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
