CREATE OR REPLACE VIEW kmdata.vw_GrantData AS
 SELECT u.user_id, w.id, w.grant_type_id, w.status_id, w.title, w.role_id, w.originating_contract, 
       w.principal_investigator, w.co_investigator, w.source, w.agency, w.priority_score, 
       w.amount_funded, w.direct_cost, w.goal, w.description, w.other_contributors, 
       w.percent_effort, w.identifier, w.grant_number, w.award_number, w.explanation_of_role, 
       w.start_date, w.end_date, w.start_year, w.start_month, w.start_day, w.end_year, 
       w.end_month, w.end_day, w.grant_identifier, w.output_text, w.submitted_year, 
       w.submitted_month, w.submitted_day, w.denied_year, w.denied_month, w.denied_day, 
       w.resource_id, w.created_at, w.updated_at,
       w.agency_other, w.agency_other_city, w.agency_other_country, w.agency_other_state_province,
       w.currency, w.fellowship, w.funding_agency_type, w.funding_amount_breakdown, w.duration, w.funding_agency_type_other,
         a.name as agency_name,                  
                  b.name as role_name,  d.name as status_name,   e.name as grant_type_name, w.appl_id, w.ongoing,                                 
                 f.name as funding_agency_type_name,   g.name as funding_amount_breakdown_name, 
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
