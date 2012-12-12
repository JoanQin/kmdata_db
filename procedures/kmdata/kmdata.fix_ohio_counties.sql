CREATE OR REPLACE FUNCTION kmdata.fix_ohio_counties (
) RETURNS BIGINT AS $$
DECLARE

   OhioCountiesCursor CURSOR FOR
      SELECT a.stusps, a.state_geoid, a.geoid, UPPER(TRIM(REPLACE(a.name, ' County', ''))) as county_name, a.intptlat, a.intptlong
      FROM kmdata.counties a
      WHERE a.stusps = 'OH';

   v_LocationTypeID BIGINT;
   v_ReturnValue INTEGER := 0;
BEGIN
   SELECT MIN(id) INTO v_LocationTypeID FROM kmdata.location_types WHERE name = 'County';

   -- loop through the cursor
   FOR currCounty IN OhioCountiesCursor LOOP

      UPDATE kmdata.locations
      SET geotype_id = currCounty.geoid,
         latitude = currCounty.intptlat,
         longitude = currCounty.intptlong
      WHERE name = currCounty.county_name
      AND location_type_id = v_LocationTypeID;

   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
