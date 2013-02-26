-- the following originally returned 13: WHERE i.term_code = '1128' AND d.subject_abbrev = 'PORTGSE'
--  (above: 24 after load error)
SELECT g.campus_name,
   i.description AS term, 
   h.session_code, 
   a.class_number, 
   d.subject_name, b.course_number, 
   c.course_name, 
   c.units_acad_prog AS credit_hours, 
   --b.acad_career,
   j.start_time, j.end_time, j.days_of_week, 
   k.name AS building_name, j.room_no, 
   a.enrollment_total,
   i.term_code, h.session_code, 
   j.start_date, j.end_date, 
   e.dept_name, 
   f.college_name, 
   l.ps_instr_assign_seq, m.inst_username AS instr_inst_username, n.display_name AS instr_display_name,
   o.name AS role_name
   ,c.description
   ,d.id AS subject_id, c.id AS course_id, b.id AS offering_id, a.id AS section_id, j.id AS meeting_id, l.id AS enrollment_id
   --,d.subject_abbrev, c.course_name, b.course_number, a.class_number, j.ps_class_mtg_number, m.inst_username
FROM ror.vw_Sections a
INNER JOIN ror.vw_Offerings b ON a.offering_id = b.id
INNER JOIN ror.vw_Courses c ON b.course_id = c.id
INNER JOIN ror.vw_Subjects d ON b.subject_id = d.id
INNER JOIN ror.vw_Departments e ON b.department_id = e.id
INNER JOIN ror.vw_Colleges f ON b.college_id = f.id
INNER JOIN ror.vw_Campuses g ON b.campus_id = g.id
INNER JOIN ror.vw_TermSessions h ON a.term_session_id = h.id
INNER JOIN ror.vw_Terms i ON h.term_id = i.id
LEFT JOIN ror.vw_SectionWeeklyMtgs j ON a.id = j.section_id
LEFT JOIN ror.vw_Buildings k ON j.building_id = k.id
LEFT JOIN ror.vw_Enrollments l ON j.id = l.section_weekly_mtg_id
LEFT JOIN ror.vw_PersonIdentifiers m ON l.person_id = m.person_id
LEFT JOIN ror.vw_People n ON m.person_id = n.id
LEFT JOIN ror.vw_EnrollmentRoles o ON l.role_id = o.id
WHERE 
   i.term_code = '1128' 
   --AND g.campus_code = 'COL' -- COL, DGC, LMA, MCH, MNS, MRN, NWK, WST
   AND d.subject_name = 'Mathematics' --d.subject_abbrev = 'PORTGSE'; d.subject_name = 'Accounting and Management Info'
ORDER BY i.term_code, h.session_code, d.subject_name, b.course_number, a.class_number
LIMIT 1000;
