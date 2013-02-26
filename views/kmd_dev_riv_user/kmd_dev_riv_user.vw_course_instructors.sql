-- View: kmd_dev_riv_user.vw_course_instructors

-- DROP VIEW kmd_dev_riv_user.vw_course_instructors;

CREATE OR REPLACE VIEW kmd_dev_riv_user.vw_course_instructors AS 
 SELECT DISTINCT l.user_id
   FROM offerings a
   LEFT JOIN courses d ON a.course_id = d.id
   LEFT JOIN subjects e ON a.subject_id = e.id
   --LEFT JOIN acad_departments f ON a.acad_department_id = f.id
   LEFT JOIN departments f ON a.department_id = f.id
   LEFT JOIN colleges g ON a.college_id = g.id
   LEFT JOIN campuses h ON a.campus_id = h.id
   LEFT JOIN institutions i ON h.institution_id = i.id
   LEFT JOIN sections k ON a.id = k.offering_id
   LEFT JOIN term_sessions b ON k.term_session_id = b.id
   LEFT JOIN terms c ON b.term_id = c.id
   LEFT JOIN section_weekly_mtgs o ON o.section_id = k.id
   LEFT JOIN enrollments l ON o.id = l.section_weekly_mtg_id
   LEFT JOIN enrollment_roles m ON l.role_id = m.id
  WHERE c.term_code::text = '1128'::text AND l.user_id IS NOT NULL AND k.enrollment_total <> 0::numeric AND o.building_id IS NOT NULL AND o.start_time IS NOT NULL AND o.days_of_week::text <> '0000000'::text AND d.active = 1;

ALTER TABLE kmd_dev_riv_user.vw_course_instructors
  OWNER TO kmd_dev_riv_user;

