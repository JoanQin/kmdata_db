CREATE OR REPLACE VIEW kmdata.vw_UserPhones AS
SELECT id, user_id, phone_type_id, phone, created_at, updated_at, resource_id
  FROM kmdata.user_phones;
