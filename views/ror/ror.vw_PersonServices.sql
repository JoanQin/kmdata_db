CREATE OR REPLACE VIEW ror.vw_PersonServices AS
SELECT w.id, w.user_id AS person_id, institution_id, service_unit_id, group_name, 
       subcommittee_name, workgroup_name, service_role_id, service_role_modifier_id, 
       start_year, active_ind, end_year, student_affairs_ind, w.created_at, 
       w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.user_services w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- w.resource_id, 