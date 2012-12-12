CREATE OR REPLACE VIEW kmdata.vw_UserHonorsAwards AS
SELECT id, user_id, resource_id, honor_type_id, honor_name, monetary_component_ind, 
       monetary_amount, fellow_ind, internal_ind, institution_id, sponsor, 
       subject, start_year, end_year, selected, competitiveness, output_text, 
       created_at, updated_at
  FROM kmdata.user_honors_awards;
