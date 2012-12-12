CREATE OR REPLACE VIEW ror.vw_PersonAddresses AS
SELECT id, user_id AS person_id, address_type_id, address1, address2, address3, address4, 
       city, state, zip, country, created_at, updated_at
  FROM kmdata.user_addresses;
-- , resource_id

--GRANT SELECT ON TABLE ror.vw_personaddresses TO kmd_ror_app_user;
--GRANT SELECT ON TABLE ror.vw_personaddresses TO kmd_dev_riv_user;
