CREATE OR REPLACE VIEW kmdata.vw_GrantData AS
 SELECT u.user_id, w.id, grant_type_id, status_id, title, role_id, originating_contract, 
       principal_investigator, co_investigator, source, agency, priority_score, 
       amount_funded, direct_cost, goal, description, other_contributors, 
       percent_effort, identifier, grant_number, award_number, explanation_of_role, 
       start_date, end_date, start_year, start_month, start_day, end_year, 
       end_month, end_day, grant_identifier, output_text, submitted_year, 
       submitted_month, submitted_day, denied_year, denied_month, denied_day, 
       w.resource_id, w.created_at, w.updated_at,
       agency_other, agency_other_city, agency_other_country, agency_other_state_province,
       currency, fellowship, funding_agency_type, funding_amount_breakdown, duration, funding_agency_type_other,
       source, co_investigator, description, explanation_of_role, agency, a.name as agency_name,
                 amount_funded, goal, grant_number, direct_cost, other_contributors, percent_effort, principal_investigator,
                 priority_score, role_id, b.name as role_name, status_id, d.name as status_name, title, grant_type_id, e.name as grant_type_name, appl_id, ongoing,
                 start_year, start_month, start_day,
                 end_year, end_month, end_day,
                 submitted_year, submitted_month, submitted_day,
                 denied_year, denied_month, denied_day,
                 agency_other, agency_other_city, agency_other_country, agency_other_state_province,
                 currency, fellowship, funding_agency_type, f.name as funding_agency_type_name,  funding_amount_breakdown, g.name as funding_amount_breakdown_name, duration, funding_agency_type_other,
       c.is_public
  FROM kmdata.grant_data w
  left join kmdata.user_grants u on u.grant_data_id = w.id
  left join researchinview.activity_import_log c on c.resource_id = w.resource_id
   left join researchinview.riv_grant_sponsors a on a.id = cast(w.agency as int)
   left join researchinview.riv_grant_roles b on b.id = w.role_id
   left join researchinview.riv_grant_statuses d on d.id = w.status_id
   left join researchinview.riv_grant_types e on e.id = w.grant_type_id
   left join researchinview.riv_grant_funding_agency_types f on f.id = cast(w.funding_agency_type as int)
   left join researchinview.riv_grant_amount_breakdowns g on g.id = w.funding_amount_breakdown;
