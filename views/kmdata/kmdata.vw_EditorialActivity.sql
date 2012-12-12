CREATE OR REPLACE VIEW kmdata.vw_EditorialActivity AS
SELECT id, user_id, editorship_type_id, modifier_id, publication_type_id, 
       publication_name, publication_issue, article_title, start_year, 
       end_year, currently_editor_ind, publication_volume, publication_date, 
       output_text, research_report_ind, titled_num, resource_id, created_at, 
       updated_at, url
  FROM kmdata.editorial_activity;
