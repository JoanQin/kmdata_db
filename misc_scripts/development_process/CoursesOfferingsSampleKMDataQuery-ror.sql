-- pre deptfix: 210 rows
-- we probably want: 70 rows
SELECT d.subject_name, c.course_number, c.course_name, 
   i.term_code, h.session_code, e.dept_code, e.department_name, f.college_name, g.campus_name
FROM ror.vw_Offerings b
INNER JOIN ror.vw_Courses c ON b.course_id = c.id
INNER JOIN ror.vw_Subjects d ON c.subject_id = d.id
INNER JOIN ror.vw_AcadDepartments e ON b.acad_department_id = e.id
INNER JOIN ror.vw_Colleges f ON e.college_id = f.id
INNER JOIN ror.vw_Campuses g ON f.campus_id = g.id
INNER JOIN ror.vw_TermSessions h ON b.term_session_id = h.id
INNER JOIN ror.vw_Terms i ON h.term_id = i.id
WHERE i.term_code = '1128' AND d.subject_abbrev = 'SPANISH'
ORDER BY i.term_code, h.session_code, d.subject_name, c.course_number;
