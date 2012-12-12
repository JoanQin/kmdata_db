CREATE OR REPLACE VIEW kmdata.vw_UserServices AS
SELECT id, user_id, resource_id, institution_id, service_unit_id, group_name, 
       subcommittee_name, workgroup_name, service_role_id, service_role_modifier_id, 
       start_year, active_ind, end_year, student_affairs_ind, created_at, 
       updated_at
  FROM kmdata.user_services;
