CREATE OR REPLACE FUNCTION kmdata.import_states (
) RETURNS BIGINT AS $$
DECLARE

   StatesCursor CURSOR FOR SELECT id, geoid, SUBSTR(UPPER(state), 1, 1000) as state, abbreviation
      FROM kmdata.states;

   v_LocationID BIGINT;
   v_ReturnValue INTEGER := 0;
BEGIN
   -- loop through the cursor
   FOR currState IN StatesCursor LOOP

      -- check to see if the location is there
      v_LocationID := kmdata.get_or_add_location_id(CAST('State' AS VARCHAR), currState.geoid, CAST(currState.state AS VARCHAR), currState.abbreviation,
         CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS VARCHAR), CAST(NULL AS VARCHAR), 
         CAST(NULL AS VARCHAR), CAST(SUBSTR(currState.abbreviation, 1, 10) AS VARCHAR), CAST(NULL AS VARCHAR));

      -- update the geo id, abbreviation, and updated at
      UPDATE kmdata.locations
      SET geotype_id = currState.geoid,
         abbreviation = currState.abbreviation,
         state = currState.abbreviation,
         updated_at = current_timestamp
      WHERE id = v_LocationID;

   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
