CREATE OR REPLACE VIEW ror.vw_narratives AS 
SELECT w.id, narrative_type_id, narrative_text, private_ind, w.user_id AS person_id, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.narratives w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- , w.resource_id

-- CAST((CASE ail.is_public WHEN 0 THEN 1 ELSE 0 END) AS SMALLINT) AS private_ind