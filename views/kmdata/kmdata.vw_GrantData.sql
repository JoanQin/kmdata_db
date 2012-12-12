CREATE OR REPLACE VIEW kmdata.vw_GrantData AS
SELECT id, grant_type_id, status_id, title, role_id, originating_contract, 
       principal_investigator, co_investigator, source, agency, priority_score, 
       amount_funded, direct_cost, goal, description, other_contributors, 
       percent_effort, identifier, grant_number, award_number, explanation_of_role, 
       start_date, end_date, start_year, start_month, start_day, end_year, 
       end_month, end_day, grant_identifier, output_text, submitted_year, 
       submitted_month, submitted_day, denied_year, denied_month, denied_day, 
       resource_id, created_at, updated_at,
       agency_other, agency_other_city, agency_other_country, agency_other_state_province,
       currency, fellowship, funding_agency_type, funding_amount_breakdown, duration, funding_agency_type_other
  FROM kmdata.grant_data;
