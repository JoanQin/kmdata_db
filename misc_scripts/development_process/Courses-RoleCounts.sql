SELECT e.role_id, r.name, COUNT(*) AS total
FROM kmdata.enrollments e
INNER JOIN kmdata.enrollment_roles r ON e.role_id = r.id
GROUP BY e.role_id, r.name
ORDER BY e.role_id;