CREATE OR REPLACE FUNCTION kmdata.import_institutions (
) RETURNS BIGINT AS $$
DECLARE

   InstitutionsCursor CURSOR FOR SELECT ir.id AS pro_id, ir.college_university_code, ir.name, ir.comment, ir.state_code,
      ir.country_id, ir.country_code, ir.college_sequence_number, ir.city_code, ir.edited_ind, ir.url
      FROM osupro.institute_ref ir
      INNER JOIN osupro.location_country_ref lcr ON ir.country_id = lcr.id
      WHERE lcr.iso = 'US' AND lcr.name = 'UNITED STATES'
      AND ir.city_code IS NOT NULL AND ir.city_code != '';

   v_LocationID BIGINT;
   v_ProCountryID BIGINT;
   v_MatchCount BIGINT;
   v_GeoID VARCHAR(255);
   v_ResourceID BIGINT;
   v_ReturnValue INTEGER := 0;
BEGIN
   -- get the US country code
   SELECT id INTO v_ProCountryID
   FROM osupro.location_country_ref
   WHERE iso = 'US'
   AND name = 'UNITED STATES';
   
   -- loop through the cursor
   FOR currRecord IN InstitutionsCursor LOOP

      -- check to see if the location is there
      IF currRecord.country_id = v_ProCountryID THEN
      
         -- use state
         SELECT COUNT(*) INTO v_MatchCount --a.geoid
         FROM kmdata.places a
         INNER JOIN kmdata.states b ON a.state_geoid = b.geoid
         WHERE a.name LIKE currRecord.city_code || '%'
         AND b.abbreviation = currRecord.state_code;

         IF v_MatchCount >= 1 THEN

            SELECT a.geoid INTO v_GeoID
            FROM kmdata.places a
            INNER JOIN kmdata.states b ON a.state_geoid = b.geoid
            WHERE a.name LIKE currRecord.city_code || '%'
            AND b.abbreviation = currRecord.state_code
            LIMIT 1;

            SELECT a.id INTO v_LocationID
            FROM kmdata.locations a
            WHERE a.geotype_id = v_GeoID;
         
         ELSE

            -- add the location
            
            v_LocationID := kmdata.get_or_add_location_id(CAST('Place' AS VARCHAR), CAST(NULL AS VARCHAR), CAST(currRecord.city_code AS VARCHAR), CAST(NULL AS VARCHAR),
               CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS VARCHAR), CAST(NULL AS VARCHAR), 
               CAST(NULL AS VARCHAR), CAST(SUBSTR(currRecord.state_code, 1, 10) AS VARCHAR), CAST(NULL AS VARCHAR));

         END IF;
         
      ELSE

         -- this is a foreign institution, IGNORE FOR NOW
         --SELECT COUNT(*) INTO v_MatchCount
         --FROM kmdata.places
         
      END IF;
      
      IF currRecord.country_id = v_ProCountryID THEN
      
         -- insert the institution
         v_ResourceID := kmdata.add_new_resource('osupro', 'institutions');
         
         INSERT INTO kmdata.institutions
            (pro_id, college_university_code, name, comment, state_code, location_id, 
             college_sequence_number, city_code, edited_ind, url, resource_id)
         VALUES
            (currRecord.pro_id, currRecord.college_university_code, currRecord.name, currRecord.comment, currRecord.state_code, v_LocationID,
             currRecord.college_sequence_number, currRecord.city_code, currRecord.edited_ind, currRecord.url, v_ResourceID);
         
      END IF;

   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
