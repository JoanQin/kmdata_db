CREATE OR REPLACE VIEW ror.vw_ClinicalTrials AS
SELECT w.id, w.user_id AS person_id, title, principal_investigator, sponsor, location_city, 
       location_state, country, start_date, end_date, start_year, start_month, 
       start_day, end_year, end_month, end_day, protocol_id, study_id, 
       clinical_trial_id, secondary_id_3, url, summary, research_report_ind, 
       role_type_id, research_report_citation, amount_funded, 
       w.created_at, w.updated_at, approved_on, 
       condition_studied, intervention_analyzed, percent_effort,
       regulatory_approval, role_other, site_name, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.clinical_trials w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 