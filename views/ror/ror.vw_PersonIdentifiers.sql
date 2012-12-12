CREATE OR REPLACE VIEW ror.vw_PersonIdentifiers AS
SELECT id, user_id AS person_id, emplid, inst_username, created_at, updated_at, idm_id
  FROM kmdata.user_identifiers;
