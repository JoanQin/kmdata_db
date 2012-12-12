-- the following originally returned 13: WHERE i.term_code = '1128' AND d.subject_abbrev = 'PORTGSE'
--  (above: 24 after load error)
SELECT i.description AS term, h.session_code, a.class_number, d.subject_name, c.course_number, c.course_name, 
   j.start_time, j.end_time, j.days_of_week, k.name AS building_name, j.room_no, 
   i.term_code, h.session_code, j.start_date, j.end_date, e.department_name, f.college_name, g.campus_name,
   m.inst_username AS instr_inst_username, n.display_name AS instr_display_name,
   o.name AS role_name,
   c.id AS course_id, d.id AS subject_id, a.id AS section_id
FROM ror.vw_Sections a
INNER JOIN ror.vw_Offerings b ON a.offering_id = b.id
INNER JOIN ror.vw_Courses c ON b.course_id = c.id
INNER JOIN ror.vw_Subjects d ON c.subject_id = d.id
INNER JOIN ror.vw_AcadDepartments e ON b.acad_department_id = e.id
INNER JOIN ror.vw_Colleges f ON e.college_id = f.id
INNER JOIN ror.vw_Campuses g ON f.campus_id = g.id
INNER JOIN ror.vw_TermSessions h ON b.term_session_id = h.id
INNER JOIN ror.vw_Terms i ON h.term_id = i.id
LEFT JOIN ror.vw_SectionWeeklyMtgs j ON a.id = j.section_id
LEFT JOIN ror.vw_Buildings k ON j.building_id = k.id
LEFT JOIN ror.vw_Enrollments l ON a.id = l.section_id
LEFT JOIN ror.vw_PersonIdentifiers m ON l.person_id = m.person_id
LEFT JOIN ror.vw_People n ON m.person_id = n.id
LEFT JOIN ror.vw_EnrollmentRoles o ON l.role_id = o.id
WHERE i.term_code = '1132' AND d.subject_name = 'Portuguese' --d.subject_abbrev = 'PORTGSE'
ORDER BY i.term_code, h.session_code, d.subject_name, c.course_number, a.class_number;
