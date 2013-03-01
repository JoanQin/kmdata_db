CREATE OR REPLACE VIEW kmdata.vw_ClinicalTrials AS
SELECT a.id, a.user_id, a.title, a.principal_investigator, a.sponsor, a.location_city, 
       a.location_state, a.country, a.start_date, a.end_date, a.start_year, a.start_month, 
       a.start_day, a.end_year, a.end_month, a.end_day, a.protocol_id, a.study_id, 
       a.clinical_trial_id, a.secondary_id_3, a.url, a.summary, a.research_report_ind, 
       a.role_type_id, a.output_text, a.research_report_citation, a.amount_funded, 
       a.resource_id, a.created_at, a.updated_at, a.approved_on, 
       a.condition_studied, a.intervention_analyzed, a.percent_effort,
       a.regulatory_approval, a.role_other, a.site_name, a.clinical_trials_identifier,
       a.human_subjects, c.name as human_subject_val, a.ongoing, b.name as ongoing_val, 
       a.vertebrate_animals_used, d.name as vertebrate_animals_val, e.name as regulatory_approval_val, 
       f.name as role_val, al.is_public, al.is_active
  FROM kmdata.clinical_trials a
  left join researchinview.activity_import_log al on al.resource_id = a.resource_id
  left join researchinview.riv_yes_no b on cast(a.ongoing as int) = b.value
  left join researchinview.riv_yes_no c on cast(a.human_subjects as int) = c.value
  left join researchinview.riv_yes_no d on cast(a.vertebrate_animals_used as int) = d.value
  left join researchinview.riv_regulatory_approva e on cast(a.regulatory_approval as int) = e.id
  left join researchinview.riv_clinical_roles f on a.role_type_id = f.id;
