CREATE OR REPLACE VIEW ror.vw_PersonPhones AS
SELECT id, user_id AS person_id, phone_type_id, country_code, phone, "extension", pref_phone_flag, created_at, updated_at
  FROM kmdata.user_phones;
-- , resource_id

--GRANT SELECT ON TABLE ror.vw_personphones TO kmd_ror_app_user;
--GRANT SELECT ON TABLE ror.vw_personphones TO kmd_dev_riv_user;
