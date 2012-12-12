CREATE OR REPLACE VIEW ror.vw_Membership AS
SELECT w.id, w.user_id AS person_id, organization_name, organization_city, organization_state, 
       organization_country, group_name, membership_role_id, membership_role_modifier_id, 
       start_year, start_month, start_day, end_year, end_month, end_day, 
       active_ind, organization_website, duration_known_ind, notes, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.membership w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 