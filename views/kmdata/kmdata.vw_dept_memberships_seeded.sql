CREATE OR REPLACE VIEW kmdata.vw_dept_memberships_seeded AS 
   SELECT DISTINCT d.dept_name, d.deptid AS inst_group_code, u.id AS user_id, ui.inst_username, u.resource_id
   FROM kmdata.departments d
   INNER JOIN kmdata.user_appointments ua ON d.deptid = ua.department_id
   INNER JOIN kmdata.users u ON ua.user_id = u.id
   INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id;

GRANT ALL ON TABLE kmdata.vw_dept_memberships_seeded TO kmdata;
GRANT SELECT ON TABLE kmdata.vw_dept_memberships_seeded TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE kmdata.vw_dept_memberships_seeded TO kmd_report_user;

