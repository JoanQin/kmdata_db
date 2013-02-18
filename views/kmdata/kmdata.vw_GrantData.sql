CREATE OR REPLACE VIEW kmdata.vw_GrantData AS
SELECT grant_data.id, grant_data.grant_type_id, grant_data.status_id, grant_data.title, grant_data.role_id, grant_data.originating_contract, 
grant_data.principal_investigator, grant_data.co_investigator, grant_data.source, grant_data.agency, grant_data.priority_score, 
grant_data.amount_funded, grant_data.direct_cost, grant_data.goal, grant_data.description, grant_data.other_contributors, 
grant_data.percent_effort, grant_data.identifier, grant_data.grant_number, grant_data.award_number, grant_data.explanation_of_role, 
grant_data.start_date, grant_data.end_date, grant_data.start_year, grant_data.start_month, grant_data.start_day, grant_data.end_year, 
grant_data.end_month, grant_data.end_day, grant_data.grant_identifier, grant_data.output_text, grant_data.submitted_year, 
grant_data.submitted_month, grant_data.submitted_day, grant_data.denied_year, grant_data.denied_month, grant_data.denied_day, 
grant_data.resource_id, grant_data.created_at, grant_data.updated_at, grant_data.agency_other, grant_data.agency_other_city, 
grant_data.agency_other_country, grant_data.agency_other_state_province, grant_data.currency, grant_data.fellowship, 
grant_data.funding_agency_type, grant_data.funding_amount_breakdown, grant_data.duration, grant_data.funding_agency_type_other,
  u.user_id, 
         a.name as agency_name,                  
                  b.name as role_name,  d.name as status_name,   e.name as grant_type_name, grant_data.appl_id, grant_data.ongoing,                                 
                 f.name as funding_agency_type_name,   g.name as funding_amount_breakdown_name, 
       c.is_public
  FROM kmdata.grant_data 
  left join kmdata.user_grants u on u.grant_data_id = grant_data.id
  left join researchinview.activity_import_log c on c.resource_id = grant_data.resource_id
   left join researchinview.riv_grant_sponsors a on a.id = cast(grant_data.agency as int)
   left join researchinview.riv_grant_roles b on b.id = grant_data.role_id
   left join researchinview.riv_grant_statuses d on d.id = grant_data.status_id
   left join researchinview.riv_grant_types e on e.id = grant_data.grant_type_id
   left join researchinview.riv_grant_funding_agency_types f on f.id = cast(grant_data.funding_agency_type as int)
   left join researchinview.riv_grant_amount_breakdowns g on g.id = grant_data.funding_amount_breakdown;
