SELECT DISTINCT d.dept_name, d.deptid AS inst_group_code, u.id AS user_id, ui.inst_username, u.resource_id
--DISTINCT 'sequence	3		'||u.resource_id||'		('||ui.inst_username||')'
FROM kmdata.departments d
INNER JOIN kmdata.user_appointments ua ON d.deptid = ua.department_id
INNER JOIN kmdata.users u ON ua.user_id = u.id
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
WHERE ui.inst_username = 'colvin.68';
--d.dept_name = 'OCIO Learning Technology';
--ORDER BY d.dept_name, ui.inst_username