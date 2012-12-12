CREATE OR REPLACE FUNCTION peoplesoft.update_campuses (
) RETURNS VARCHAR AS $$
DECLARE
   --v_ReturnValue BIGINT;
   v_MatchCount BIGINT;
   v_ResourceID BIGINT;
   --v_LocTypeID BIGINT;
   v_LocationID BIGINT;
   v_InstitutionID BIGINT;

   v_CampusesUpdated INTEGER;
   v_CampusesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
   CUR_Campuses CURSOR FOR
      SELECT campus, descr, descrshort, institution, effdt, src_sys_id, eff_status, "location", facility_conflict
        FROM peoplesoft.ps_campus_tbl;
BEGIN
   v_CampusesUpdated := 0;
   v_CampusesInserted := 0;
   v_ReturnString := '';
   --v_ReturnValue := 0;
   v_MatchCount := 0;

   -- get location type of 'Place'
   --SELECT id INTO v_LocTypeID FROM kmdata.location_types WHERE name = 'Place';

   -- get the institution ID
   SELECT id INTO v_InstitutionID FROM kmdata.institutions
    WHERE name = 'Ohio State University, The' AND city_code = 'Columbus' AND state_code = 'OH' AND college_university_code = '001592';

   FOR currCampus IN CUR_Campuses LOOP

      -- get location name of 'COLUMBUS' for location type of Place
      --SELECT id INTO v_LocationID FROM kmdata.locations WHERE location_type_id = v_LocTypeID AND state = 'Ohio' AND name = upper(currCampus.descr);
      v_LocationID := kmdata.get_or_add_location_id('Place', NULL, upper(currCampus.descr), NULL, NULL, NULL, NULL, NULL, NULL, 'Ohio', NULL);

      -- get the count
      SELECT COUNT(*) INTO v_MatchCount
        FROM kmdata.campuses
       WHERE campus_name = currCampus.descr;

      IF v_MatchCount = 0 THEN

         INSERT INTO kmdata.campuses
            (id, campus_name, institution_id, location_id, resource_id)
         VALUES
            (nextval('kmdata.campuses_id_seq'), currCampus.descr, v_InstitutionID, v_LocationID, kmdata.add_new_resource('peoplesoft', 'campuses'));

         v_CampusesInserted := v_CampusesInserted + 1;
      
      ELSE

         UPDATE kmdata.campuses
            SET location_id = v_LocationID
          WHERE campus_name = currCampus.descr;
          
         v_CampusesUpdated := v_CampusesUpdated + 1;
         
      END IF;
      
   END LOOP;

   v_ReturnString := 'Campus import completed. ' || CAST(v_CampusesUpdated AS VARCHAR) || ' campuses updated and ' || CAST(v_CampusesInserted AS VARCHAR) || ' campuses inserted.';
   
   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
