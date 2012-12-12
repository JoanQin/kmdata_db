CREATE OR REPLACE VIEW kmdata.vw_UserAddresses AS
SELECT id, user_id, address_type_id, address1, address2, address3, address4, 
       city, state, zip, created_at, updated_at, resource_id
  FROM kmdata.user_addresses;
