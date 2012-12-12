CREATE OR REPLACE VIEW kmdata.users_vw AS 
SELECT u.id, u.uuid, u.open_id, u.last_name, u.first_name, u.middle_name, u.created_at, 
       u.updated_at, u.resource_id, u.name_prefix, u.name_suffix, u.display_name
  FROM kmdata.users u
 WHERE u.deceased_ind = 0;
