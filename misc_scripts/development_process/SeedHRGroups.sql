SELECT DISTINCT d.dept_name, d.deptid, u.id AS user_id, ui.inst_username, u.resource_id
FROM kmdata.departments d
INNER JOIN kmdata.user_appointments ua ON d.deptid = ua.department_id
INNER JOIN kmdata.users u ON ua.user_id = u.id
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
ORDER BY d.dept_name, ui.inst_username;