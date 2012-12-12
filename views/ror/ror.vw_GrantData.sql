CREATE OR REPLACE VIEW ror.vw_GrantData AS
SELECT w.id, grant_type_id, status_id, title, role_id, originating_contract, 
       principal_investigator, co_investigator, source, agency, priority_score, 
       amount_funded, direct_cost, goal, description, other_contributors, 
       percent_effort, identifier, grant_number, award_number, explanation_of_role, 
       start_date, end_date, start_year, start_month, start_day, end_year, 
       end_month, end_day, grant_identifier, submitted_year, 
       submitted_month, submitted_day, denied_year, denied_month, denied_day, 
       w.created_at, w.updated_at,
       agency_other, agency_other_city, agency_other_country, agency_other_state_province,
       currency, fellowship, funding_agency_type, funding_amount_breakdown, duration, funding_agency_type_other,
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.grant_data w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 