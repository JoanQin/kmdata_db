CREATE OR REPLACE VIEW kmdata.vw_UserIdentifiers AS
SELECT id, user_id, emplid, inst_username, created_at, updated_at, idm_id
  FROM kmdata.user_identifiers;
