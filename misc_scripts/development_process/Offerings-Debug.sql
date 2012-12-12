      SELECT DISTINCT NULL AS offering_name, c.id AS course_id, ts.id AS term_session_id, ad.id AS acad_department_id
      FROM
      (
         SELECT yearQuarterCode AS term_code, campusId AS campus_name, departmentNumber AS subject_abbrev, 
            courseNumber AS course_number, session_code, acad_group, acad_org
           FROM sid.osu_offering ai
           --WHERE yearQuarterCode = '1128' AND departmentNumber = 'SPANISH'
         EXCEPT
         SELECT ti.term_code, cai.campus_name, si.subject_abbrev, coi.course_number, tsi.session_code, ci.acad_group, adi.dept_code AS acad_org
           FROM kmdata.offerings bi
           INNER JOIN kmdata.term_sessions tsi ON bi.term_session_id = tsi.id
           INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
           INNER JOIN kmdata.acad_departments adi ON bi.acad_department_id = adi.id
           INNER JOIN kmdata.colleges ci ON adi.college_id = ci.id
           INNER JOIN kmdata.campuses cai ON ci.campus_id = cai.id
           INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
           INNER JOIN kmdata.subjects si ON coi.subject_id = si.id
      ) chgoffer
      INNER JOIN kmdata.courses c ON chgoffer.course_number = c.course_number
      INNER JOIN kmdata.subjects s ON c.subject_id = s.id AND chgoffer.subject_abbrev = s.subject_abbrev
      INNER JOIN kmdata.terms t ON chgoffer.term_code = t.term_code
      INNER JOIN kmdata.term_sessions ts ON chgoffer.session_code = ts.session_code AND t.id = ts.term_id
      INNER JOIN kmdata.colleges col ON chgoffer.acad_group = col.acad_group
      INNER JOIN kmdata.acad_departments ad ON col.id = ad.college_id AND chgoffer.acad_org = ad.dept_code AND s.acad_org = ad.dept_code AND s.subject_abbrev = ad.abbreviation
      INNER JOIN kmdata.campuses cam ON chgoffer.campus_name = cam.ps_location_name AND col.campus_id = cam.id
      WHERE t.term_code = '1128' AND s.subject_abbrev = 'SPANISH';
