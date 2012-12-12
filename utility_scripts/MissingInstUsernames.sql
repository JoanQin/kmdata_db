SELECT DISTINCT ui.user_id, u.last_name, u.first_name, u.middle_name, dept.deptid, dept.dept_name, ua.title, ua.working_title, ui.inst_username
FROM kmdata.user_identifiers ui
INNER JOIN kmdata.user_appointments ua ON ui.user_id = ua.user_id
INNER JOIN kmdata.users u ON ui.user_id = u.id
INNER JOIN kmdata.departments dept ON ua.department_id = dept.deptid
WHERE ui.inst_username IS NULL
ORDER BY u.last_name, u.first_name, u.middle_name, ui.user_id, dept.deptid, dept.dept_name, ua.title, ua.working_title;