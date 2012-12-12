-- NOTE: SHOULD LOCATION BE A RESOURCE???
CREATE OR REPLACE FUNCTION kmdata.get_or_add_location_id (
   p_LocationTypeName VARCHAR(255),
   p_GeotypeID VARCHAR(255),
   p_Name VARCHAR(1000),
   p_Abbreviation VARCHAR(100),
   p_Latitude NUMERIC(10,6),
   p_Longitude NUMERIC(10,6),
   p_Address VARCHAR(2000),
   p_Address2 VARCHAR(2000),
   p_City VARCHAR(255),
   p_State VARCHAR(10),
   p_Zip VARCHAR(255),
   p_CreatedAt TIMESTAMP DEFAULT current_timestamp,
   p_UpdatedAt TIMESTAMP DEFAULT current_timestamp
) RETURNS BIGINT AS $$
DECLARE
   v_LocationTypeCount BIGINT := 0;
   v_LocationTypeID BIGINT;
   v_LocationCountByName BIGINT := 0;
   v_LocationCountByGeoID BIGINT := 0;
   v_LocationCountByLatLong BIGINT := 0;
   v_NewLocationID BIGINT := 0;
BEGIN
   -- select count from location types
   SELECT COUNT(*) INTO v_LocationTypeCount FROM kmdata.location_types WHERE name = p_LocationTypeName;

   IF v_LocationTypeCount > 0 THEN
      -- get the type
      SELECT MIN(id) INTO v_LocationTypeID FROM kmdata.location_types WHERE name = p_LocationTypeName;
   ELSE
      -- insert the type
      v_LocationTypeID := nextval('kmdata.location_types_id_seq');

      INSERT INTO kmdata.location_types
         (id, name, created_at, updated_at)
      VALUES
         (v_LocationTypeID, p_LocationTypeName, current_timestamp, current_timestamp);
   END IF;

   -- select count from one of several ways

   SELECT COUNT(*) INTO v_LocationCountByGeoID
   FROM kmdata.locations l
   WHERE l.geotype_id = p_GeotypeID
   AND l.geotype_id IS NOT NULL;
   
   SELECT COUNT(*) INTO v_LocationCountByName
   FROM kmdata.locations l
   WHERE l.location_type_id = v_LocationTypeID
   AND l.name = UPPER(p_Name)
   AND l.location_type_id IS NOT NULL
   AND l.name IS NOT NULL;

   SELECT COUNT(*) INTO v_LocationCountByLatLong
   FROM kmdata.locations l
   WHERE l.latitude = p_Latitude
   AND l.longitude = p_Longitude
   AND l.latitude IS NOT NULL
   AND l.longitude IS NOT NULL;

   IF v_LocationCountByGeoID > 0 THEN
   
      -- get location by geo id
      SELECT MIN(id) INTO v_NewLocationID
      FROM kmdata.locations l
      WHERE l.geotype_id = p_GeotypeID;
      
   ELSIF v_LocationCountByName > 0 THEN
   
      -- get location by type/name
      SELECT MIN(id) INTO v_NewLocationID
      FROM kmdata.locations l
      WHERE l.location_type_id = v_LocationTypeID
      AND l.name = p_Name;
      
   ELSIF v_LocationCountByLatLong > 0 THEN
   
      -- get location by lat/lon
      SELECT MIN(id) INTO v_NewLocationID
      FROM kmdata.locations l
      WHERE l.latitude = p_Latitude
      AND l.longitude = p_Longitude;
      
   ELSIF (p_GeotypeID IS NOT NULL AND TRIM(p_GeotypeID) != '') OR
      (v_LocationTypeID IS NOT NULL AND p_Name IS NOT NULL AND TRIM(p_Name) != '') OR
      (p_Latitude IS NOT NULL AND p_Longitude IS NOT NULL) THEN
   
      -- select the  next sequence value
      v_NewLocationID := nextval('kmdata.locations_id_seq');
   
      -- insert the location
      INSERT INTO kmdata.locations
         (id, location_type_id, geotype_id, name, abbreviation, latitude, longitude,
          address, address2, city, state, zip, created_at, updated_at)
      VALUES
         (v_NewLocationID, v_LocationTypeID, p_GeotypeID, UPPER(p_Name), UPPER(p_Abbreviation), p_Latitude, p_Longitude,
          p_Address, p_Address2, p_City, p_State, p_Zip, p_CreatedAt, p_UpdatedAt);
          
   ELSE

      -- error: no key match provided
      RAISE EXCEPTION 'No alternate key provided for location %, %', p_LocationTypeName, p_Name;
      
   END IF;

   -- return the sequence value
   RETURN v_NewLocationID;
END;
$$ LANGUAGE plpgsql;
