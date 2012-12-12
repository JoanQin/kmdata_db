CREATE OR REPLACE VIEW ror.vw_People AS
SELECT id, open_id, last_name, first_name, middle_name, created_at, 
       updated_at, name_prefix, name_suffix, display_name, 
       deceased_ind, resource_id
  FROM kmdata.users;
-- uuid, 