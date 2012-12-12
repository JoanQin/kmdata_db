CREATE OR REPLACE FUNCTION kmdata.import_places (
) RETURNS BIGINT AS $$
DECLARE

   PlacesCursor CURSOR FOR SELECT id, stusps, state_geoid, geoid, name, intptlat, intptlong
      FROM kmdata.places;

   v_LocationID BIGINT;
   v_StateAbbrev VARCHAR(50);
   v_ReturnValue INTEGER := 0;
BEGIN
   -- loop through the cursor
   FOR currPlace IN PlacesCursor LOOP

      SELECT abbreviation INTO v_StateAbbrev
      FROM kmdata.states
      WHERE geoid = currPlace.state_geoid;
      
      -- check to see if the location is there
      v_LocationID := kmdata.get_or_add_location_id(CAST('Place' AS VARCHAR), currPlace.geoid, CAST(currPlace.name AS VARCHAR), CAST(NULL AS VARCHAR),
         CAST(currPlace.intptlat AS NUMERIC), CAST(currPlace.intptlong AS NUMERIC), CAST(NULL AS VARCHAR), CAST(NULL AS VARCHAR), 
         CAST(NULL AS VARCHAR), CAST(v_StateAbbrev AS VARCHAR), CAST(NULL AS VARCHAR));

   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
