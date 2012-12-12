CREATE OR REPLACE VIEW kmdata.vw_Locations AS
SELECT id, location_type_id, created_at, updated_at, latitude, longitude, 
       address, address2, city, state, zip, geotype_id, name, abbreviation
  FROM kmdata.locations;
