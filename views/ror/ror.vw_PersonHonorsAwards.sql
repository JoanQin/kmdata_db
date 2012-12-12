CREATE OR REPLACE VIEW ror.vw_PersonHonorsAwards AS
SELECT w.id, w.user_id AS person_id, honor_type_id, honor_name, monetary_component_ind, 
       monetary_amount, fellow_ind, internal_ind, institution_id, sponsor, 
       subject, start_year, end_year, selected, competitiveness, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.user_honors_awards w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- w.resource_id, output_text, 