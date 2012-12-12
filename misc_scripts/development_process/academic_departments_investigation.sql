SELECT DISTINCT a.department_id, b.dept_name, COUNT(*) AS appt_count
FROM kmdata.user_appointments a
INNER JOIN kmdata.departments b ON a.department_id = b.deptid
WHERE a.title LIKE '%Professor%' OR a.title LIKE '%Faculty%'
GROUP BY a.department_id, b.dept_name
ORDER BY 2;
--LIMIT 2000;


SELECT * FROM kmdata.departments WHERE upper(dept_name) LIKE '%LATINO%' ORDER BY dept_name, deptid;

