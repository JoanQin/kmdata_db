CREATE OR REPLACE VIEW ror.vw_PersonNarratives AS
SELECT id, user_id AS person_id, narrative_id
  FROM kmdata.user_narratives;
