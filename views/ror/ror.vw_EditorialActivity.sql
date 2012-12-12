CREATE OR REPLACE VIEW ror.vw_EditorialActivity AS
SELECT w.id, w.user_id AS person_id, editorship_type_id, modifier_id, publication_type_id, 
       publication_name, publication_issue, article_title, start_year, 
       end_year, currently_editor_ind, publication_volume, publication_date, 
       research_report_ind, titled_num, w.created_at, 
       w.updated_at, url, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.editorial_activity w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 