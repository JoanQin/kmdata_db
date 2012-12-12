CREATE OR REPLACE VIEW kmdata.vw_UserNarratives AS
SELECT id, user_id, narrative_id
  FROM kmdata.user_narratives;
