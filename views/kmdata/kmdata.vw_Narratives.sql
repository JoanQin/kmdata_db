CREATE OR REPLACE VIEW kmdata.vw_narratives AS 
SELECT id, narrative_type_id, narrative_text, private_ind, user_id, 
       created_at, updated_at, resource_id
  FROM kmdata.narratives;
