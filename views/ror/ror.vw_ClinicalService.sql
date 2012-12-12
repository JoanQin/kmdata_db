CREATE OR REPLACE VIEW ror.vw_ClinicalService AS
SELECT w.id, w.user_id AS person_id, clinical_service_type_id, start_date, end_date, 
       title, duration, location, department, description, 
       w.created_at, w.updated_at, url, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM clinical_service w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 