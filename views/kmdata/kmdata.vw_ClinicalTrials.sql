CREATE OR REPLACE VIEW kmdata.vw_ClinicalTrials AS
SELECT id, user_id, title, principal_investigator, sponsor, location_city, 
       location_state, country, start_date, end_date, start_year, start_month, 
       start_day, end_year, end_month, end_day, protocol_id, study_id, 
       clinical_trial_id, secondary_id_3, url, summary, research_report_ind, 
       role_type_id, output_text, research_report_citation, amount_funded, 
       resource_id, created_at, updated_at, approved_on, 
       condition_studied, intervention_analyzed, percent_effort,
       regulatory_approval, role_other, site_name
  FROM clinical_trials;
