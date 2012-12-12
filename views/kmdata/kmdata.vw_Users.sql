CREATE OR REPLACE VIEW kmdata.vw_Users AS
SELECT id, uuid, open_id, last_name, first_name, middle_name, created_at, 
       updated_at, resource_id, name_prefix, name_suffix, display_name, 
       deceased_ind
  FROM kmdata.users;
