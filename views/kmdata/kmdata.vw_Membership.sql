CREATE OR REPLACE VIEW kmdata.vw_Membership AS
SELECT id, user_id, organization_name, organization_city, organization_state, 
       organization_country, group_name, membership_role_id, membership_role_modifier_id, 
       start_year, start_month, start_day, end_year, end_month, end_day, 
       active_ind, organization_website, duration_known_ind, notes, 
       output_text, resource_id, created_at, updated_at
  FROM kmdata.membership;
